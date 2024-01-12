from datetime import datetime
from django.contrib.auth import authenticate
from django.core.files.storage import FileSystemStorage
from ninja import NinjaAPI, Router, Form, UploadedFile, File
from ninja_extra import api_controller, route
from ninja_jwt.authentication import JWTAuth
from ninja.orm import create_schema
from ninja_jwt.controller import NinjaJWTDefaultController
from ninja_extra import NinjaExtraAPI
from ninja_jwt.authentication import JWTAuth
from ninja_jwt.tokens import RefreshToken

from .models import User, UserAuthToken
from .schema import Error, MyTokenObtainPairOutSchema, SlimUserSchema, UserSchema, UpdateUserSchema
from .tasks import send_email_auth_token


STORAGE = FileSystemStorage()
api = NinjaExtraAPI()

""" AUTH Related APIs """
# get Tokens
# api.register_controllers(NinjaJWTDefaultController)

@api_controller("auth/", tags=['Auth'])
class AuthAPI:
    # JWT Token
    @route.post("token", response={200: MyTokenObtainPairOutSchema, 403: Error})
    def jwt_tokens(self, request, data: create_schema(UserAuthToken, fields=['token']) ):
        uat = UserAuthToken.objects.get(token = data.dict()['token'])
        if uat.is_valid:
            user = uat.user
            if uat.type == UserAuthToken.REGISTER:
                user.verifiedEmail = True
                user.save()

            refresh = RefreshToken.for_user(user)
            return {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': user
            }
        return 403, {"detail": "Auth token code has expired"}
    
    # Login
    @route.post("login", response={200: create_schema(User, fields=['fullName', 'email']), 403: Error})
    def login(self, request, data: create_schema(User, fields=['email', 'password'])):
        user = authenticate(email=data.dict()['email'], password=data.dict()['password'])
        if user:
            # send auth code
            send_email_auth_token(user, UserAuthToken.LOGIN)
            return user
        return 403, {"detail": "Invalid credentials"}

    # Registration
    @route.post("registration", response={200: create_schema(User, fields=['fullName', 'email', 'id']), 403: Error})
    def registration(self, request, data: create_schema(User, fields=['email', 'fullName', 'password'])):
        user = User.objects.create_user(**data.dict())  
        if user:  
            # send auth code
            send_email_auth_token(user, UserAuthToken.REGISTER)
            return user   
        return 403, {"detail": "User already exists or invalid credentials"} 

api.register_controllers(AuthAPI)

""" USER Related APIs"""
@api_controller("user/", tags=["User"], auth= JWTAuth())
class UserAPI:    
    # slim details
    @route.get("slim", response=SlimUserSchema)
    def slim_details(self, request):
        return request.user
    
    # details
    @route.get("details", response=UserSchema)
    def details(self, request):
        return request.user
    
    # update details
    @route.put("update", response=UserSchema)
    def update(self, request, data: UpdateUserSchema):
        user = request.user
        print(data.dict().items())
        for attr, value in data.dict(exclude_unset=True).items():
            setattr(user, attr, value)
        user.save()
        return user
    
    # uplod profile picture 
    @route.post("upload-pp", response=UserSchema)
    def upload_pp(self, request, file: UploadedFile = File(...)):
        user = request.user
        user.profilePicture.save(file.name, file)
        return user
    

    # uplod profile picture 
    @route.post("verify", response=SlimUserSchema)
    def verification(self, request, file: UploadedFile = File(...)):
        user = request.user
        id_img = STORAGE.save(file.name, file)
        # process the image
        return user
    

    # delete account
    @route.delete("delete")
    def remove(self, request):
        user = request.user
        user.delete()
        return 
    
        
api.register_controllers(UserAPI)


""" SHOP Related APIs """