from django.contrib.auth import authenticate
from ninja import NinjaAPI, Router, Form
from ninja_extra import api_controller, route
from ninja_jwt.authentication import JWTAuth
from ninja.orm import create_schema
from ninja_jwt.controller import NinjaJWTDefaultController
from ninja_extra import NinjaExtraAPI

from .models import User, UserAuthToken
from .tasks import send_email_auth_token


api = NinjaExtraAPI()

""" AUTH Related APIs """
# get Tokens
api.register_controllers(NinjaJWTDefaultController)

@api_controller("auth/", tags=['Auth'])
class AuthAPI:
    # Login
    @route.post("/registration", response=create_schema(User, fields=['fullName', 'email']))
    def login(request, data: create_schema(User, fields=['email', 'password'])):
        user = authenticate(email=data.dict()['email'], password=data.dict()['password'])
        # send auth code
        send_email_auth_token(user, UserAuthToken.LOGIN)
        return user if user else {"detail": "Invalid credentials"}

    # Registration
    @route.post("/registration", response=create_schema(User, fields=['fullName', 'email', 'id']))
    def registration(request, data: create_schema(User, fields=['email', 'fullName', 'password'])):
        user = User.objects.create_user(**data.dict())    
        # send auth code
        send_email_auth_token(user, UserAuthToken.REGISTER)
        return user
    

""" USER Related APIs"""
@api_controller
class UserAPI:
    def __init__(self) -> None:
        self.user = self.request.user
    
    # slim details
    # details
    # update details
    # upload ID to verify
    # deactiavate account        
    # delete account

""" SHOP Related APIs """