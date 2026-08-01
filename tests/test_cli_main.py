"""Tests for d2x.cli.main module."""

import pytest
from click.testing import CliRunner
from d2x.cli.main import d2x_cli


@pytest.fixture
def runner():
    """Create a Click test runner."""
    return CliRunner()


class TestD2xCli:
    """Test suite for D2X CLI."""

    def test_cli_group_exists(self, runner):
        """Test that the CLI group is callable."""
        result = runner.invoke(d2x_cli, ["--help"])
        assert result.exit_code == 0
        assert "login-url" in result.output or "login_url" in result.output

    def test_login_url_help(self, runner):
        """Test login-url command help."""
        result = runner.invoke(d2x_cli, ["login-url", "--help"])
        assert result.exit_code == 0

    def test_auth_url_help(self, runner):
        """Test auth-url command help."""
        result = runner.invoke(d2x_cli, ["auth-url", "--help"])
        assert result.exit_code == 0
