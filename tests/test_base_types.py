"""Tests for d2x.base.types module."""

import pytest
from d2x.base.types import OutputFormat, CLIOptions


class TestOutputFormat:
    """Test suite for OutputFormat enum."""

    def test_json_value(self):
        assert OutputFormat.JSON.value == "json"

    def test_yaml_value(self):
        assert OutputFormat.YAML.value == "yaml"

    def test_text_value(self):
        assert OutputFormat.TEXT.value == "text"

    def test_markdown_value(self):
        assert OutputFormat.MARKDOWN.value == "markdown"


class TestCLIOptions:
    """Test suite for CLIOptions model."""

    def test_default_values(self):
        options = CLIOptions()
        assert options.output_format == OutputFormat.TEXT
        assert options.debug is False

    def test_custom_output_format(self):
        options = CLIOptions(output_format=OutputFormat.JSON)
        assert options.output_format == OutputFormat.JSON

    def test_debug_mode(self):
        options = CLIOptions(debug=True)
        assert options.debug is True
