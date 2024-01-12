from ninja.orm import create_schema
from ninja import Schema
from .models import User

SlimUserSchema = create_schema(User, fields=['email', 'fullName', 'id', 'verifiedEmail', 'verified'])
UserSchema = create_schema(User, fields=['id', 'fullName', 'email', 'verifiedEmail', 'phone', 'sex', 'profilePicture', 'verified', 'joinedOn'])
UpdateUserSchema = create_schema(User, fields=['fullName', 'email', 'phone', 'sex'], \
                                optional_fields=['fullName', 'email', 'phone', 'sex'])

class MyTokenObtainPairOutSchema(Schema):
    refresh: str
    access: str
    user: SlimUserSchema
class Error(Schema):
    detail: str