from pydantic import BaseModel, ConfigDict
from rich.table import Table
from typing import Optional
from datetime import datetime, timedelta


class CommonBaseModel(BaseModel):
    """Common base class for all models"""

    model_config = ConfigDict(
        from_attributes=True,
        populate_by_name=True,
        use_enum_values=True,
    )

    def to_dict(self):
        """Convert model to dictionary"""
        return self.model_dump(by_alias=True)

    def to_json(self):
        """Convert model to JSON string"""
        return self.model_dump_json(by_alias=True)

    def to_yaml(self):
        """Convert model to YAML string"""
        try:
            import yaml
        except ImportError:
            raise ImportError(
                "PyYAML is not installed. Please install it to use this method."
            )
        return yaml.dump(self.model_dump(by_alias=True))

    @classmethod
    def from_yaml(cls, yaml_str: str):
        """Create model instance from YAML string"""
        try:
            import yaml
        except ImportError:
            raise ImportError(
                "PyYAML is not installed. Please install it to use this method."
            )
        data = yaml.safe_load(yaml_str)
        return cls(**data)

    @classmethod
    def from_dict(cls, data: dict):
        """Create model instance from dictionary"""
        return cls(**data)

    @classmethod
    def from_json(cls, json_str: str):
        """Create model instance from JSON string"""
        return cls.parse_raw(json_str)

    def to_openapi_schema(self):
        """Convert model to OpenAPI 3.1 schema"""
        return self.model_json_schema()
