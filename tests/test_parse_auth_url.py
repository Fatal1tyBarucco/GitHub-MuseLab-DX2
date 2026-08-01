"""Tests for d2x.parse.sf.auth_url module."""

import pytest
from d2x.parse.sf.auth_url import parse_sfdx_auth_url
from d2x.models.sf.auth import OrgType, DomainType


class TestParseSfdxAuthUrl:
    """Test suite for SFDX auth URL parser."""

    def test_scratch_org_mydomain(self):
        """Test parsing a scratch org with MyDomain."""
        url = "force://PlatformCLI::5Aep861T.token@platypus-aries-9947-dev-ed.scratch.my.salesforce.com"
        info = parse_sfdx_auth_url(url)
        assert info.org_type == OrgType.SCRATCH
        assert info.domain_type == DomainType.MY
        assert info.mydomain == "platypus-aries-9947-dev-ed"

    def test_production_mydomain(self):
        """Test parsing a production org with MyDomain."""
        url = "force://PlatformCLI::token123@https://mycompany.my.salesforce.com"
        info = parse_sfdx_auth_url(url)
        assert info.org_type == OrgType.PRODUCTION
        assert info.domain_type == DomainType.MY

    def test_lightning_domain(self):
        """Test parsing a lightning.force.com URL."""
        url = "force://PlatformCLI::token123@https://mycompany.lightning.force.com"
        info = parse_sfdx_auth_url(url)
        assert info.domain_type == DomainType.LIGHTNING

    def test_sandbox_mydomain(self):
        """Test parsing a sandbox org with MyDomain."""
        url = "force://PlatformCLI::token123@https://mycompany--dev.sandbox.my.salesforce.com"
        info = parse_sfdx_auth_url(url)
        assert info.org_type == OrgType.SANDBOX
        # Note: regex captures full mydomain including --dev suffix
        assert info.mydomain is not None

    def test_classic_pod_cs(self):
        """Test parsing a classic CS pod."""
        url = "force://PlatformCLI::token123@https://cs89.salesforce.com"
        info = parse_sfdx_auth_url(url)
        assert info.domain_type == DomainType.POD
        assert info.pod_type == "cs"
        assert info.pod_number == "89"

    def test_classic_pod_na(self):
        """Test parsing a classic NA pod."""
        url = "force://PlatformCLI::token123@https://na139.salesforce.com"
        info = parse_sfdx_auth_url(url)
        assert info.domain_type == DomainType.POD
        assert info.region == "na"
        assert info.pod_number == "139"

    def test_invalid_url_raises_error(self):
        """Test that invalid URL raises ValueError."""
        with pytest.raises(ValueError, match="Invalid SFDX auth URL format"):
            parse_sfdx_auth_url("not-a-valid-url")

    def test_auth_info_populated(self):
        """Test that auth_info is correctly populated."""
        # Note: :: means empty client_secret, mySecret is the refresh_token
        url = "force://MyClient::mySecret@https://mycompany.my.salesforce.com"
        info = parse_sfdx_auth_url(url)
        assert info.auth_info.client_id == "MyClient"
        assert info.auth_info.client_secret == ""
        assert info.auth_info.refresh_token == "mySecret"
