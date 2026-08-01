"""Tests for d2x.base.models module."""

import pytest
from d2x.base.models import CommonBaseModel


class TestCommonBaseModel:
    """Test suite for CommonBaseModel."""

    def test_to_dict(self):
        """Test that to_dict returns a dictionary."""
        model = CommonBaseModel()
        result = model.to_dict()
        assert isinstance(result, dict)

    def test_to_json(self):
        """Test that to_json returns a JSON string."""
        model = CommonBaseModel()
        result = model.to_json()
        assert isinstance(result, str)
        assert "{" in result

    def test_from_dict(self):
        """Test creating instance from dict."""
        model = CommonBaseModel.from_dict({})
        assert isinstance(model, CommonBaseModel)
