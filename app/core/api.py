from typing import List
from django.shortcuts import get_object_or_404
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
from ninja.responses import codes_4xx

from .utils import gen_shop_membeship_join_token
from .models import User, UserAuthToken, Shop, Item, ItemImage, ShopMembership, Order, ShopMembershipToken, Pricing
from .schema import Error, ItemImageSchema, MyTokenObtainPairOutSchema, PricingSchema, PricingSchemaIn, SlimUserSchema, UserSchema, UpdateUserSchema, ShopSchema, ItemSchema, ItemSchemaIn
from .tasks import send_email_auth_token, send_email_shop_membership_join_token


STORAGE = FileSystemStorage()
api = NinjaExtraAPI()

""" AUTH Related APIs """
# get Tokens
# api.register_controllers(NinjaJWTDefaultController)

@api_controller("auth/", tags=['Auth'])
class AuthAPI:
    # JWT Token
    @route.post("token", response={200: MyTokenObtainPairOutSchema, codes_4xx: Error})
    def jwt_tokens(self, request, data: create_schema(UserAuthToken, fields=['token']) ):
        uat = UserAuthToken.objects.get(token = data.dict()['token'])
        if uat.is_valid:
            user = uat.user
            if uat.type == UserAuthToken.REGISTER:
                user.verifiedEmail = True
                user.save()
            
            uat.valid = False
            uat.save()

            refresh = RefreshToken.for_user(user)
            return {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': user
            }
        return 403, {"detail": "Auth token code has expired"}
    
    # Login
    @route.post("login", response={200: create_schema(User, fields=['fullName', 'email']), codes_4xx: Error})
    def login(self, request, data: create_schema(User, fields=['email', 'password'])):
        user = authenticate(email=data.dict()['email'], password=data.dict()['password'])
        if user:
            # send auth code
            send_email_auth_token(user, UserAuthToken.LOGIN)
            return user
        return 403, {"detail": "Invalid credentials"}

    # Registration
    @route.post("registration", response={200: create_schema(User, fields=['fullName', 'email', 'id']), codes_4xx: Error})
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
        for attr, value in data.dict(exclude_unset=True).items():
            setattr(user, attr, value)
        user.save()
        return user
    
    # uplod profile picture 
    @route.post("upload-pp", response=UserSchema)
    def upload_profile_picture(self, request, file: UploadedFile = File(...)):
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
     
    # user listed items
           
api.register_controllers(UserAPI)


""" SHOP Related APIs """
@api_controller("shop/", tags=["Shop"])
class ShopAPI:
    """ NON Auth APIs """
    # create shop
    @route.post("new", response=ShopSchema, auth=JWTAuth())
    def create(self, request, data: ShopSchema, file: UploadedFile = File(...)):
        shop = Shop(**data.dict())
        shop.coverImage.save(file.name, file)
        # make user the owner
        sm = ShopMembership.objects.create(user=request.user, shop=shop, role=ShopMembership.OWNER)
        return shop
    
    # update shop
    @route.put("{slug:slug}/update", auth=JWTAuth())
    def update(self, request, slug, data):
        shop = get_object_or_404(Shop, slug=slug)
        return shop
    
    # upload shop cover image
    @route.post("{slug:slug}/upload-ci", auth=JWTAuth())
    def upload_cover_image(self, request, slug, file: UploadedFile = File(...)):
        shop = get_object_or_404(Shop, slug=slug)
        return shop
      
    # create add staff code
    @route.post('{slug:slug}/join-token', response=create_schema(ShopMembershipToken, fields=['token', 'validTill']), auth=JWTAuth())
    def join_token(self, request, slug, data: create_schema(User, fields=['email'])):
        email_to = data.dict()['email']
        shop = get_object_or_404(Shop, slug=slug)
        token = gen_shop_membeship_join_token(shop=shop, user=request.user)
        send_email_shop_membership_join_token(token, email_to)
        return token
    
    # staff join using code
    @route.post('join', response={200: create_schema(ShopMembership, fields=['role', 'shop', 'role']), codes_4xx: Error}, auth=JWTAuth())
    def join(self, request, data: create_schema(ShopMembershipToken, fields=['token'])):
        token = ShopMembershipToken.objects.get(token=data.dict()['token'])
        if token.is_valid:
            sm = ShopMembership.objects.create(user=request.user, shop=token.shop, role=token.role)
            token.user =request.user
            token.save()
            return sm
        return 403, {"detail": "Join token has expired"}

    # list staff
    # payments
    # transactions and wallet
    # rented items
    # deleted

    """ NON Auth APIs """
    # shop details
    @route.get("{slug:slug}/details", response=ShopSchema)
    def details(self, request, slug):
        shop = get_object_or_404(Shop, slug=slug)
        return shop

    # list shop(dealership or whatever) items(cars or whatever)
    @route.get("{slug:slug}/items", response=List[ItemSchema])
    def items(self, request, slug):
        shop = Shop.objects.prefetch_related("items").get(slug=slug)
        return shop.items.all()

api.register_controllers(ShopAPI)

""" Item Related APIs """
@api_controller("item/", tags=["Item"])
class ItemAPI:
    """ Auth APIs """
    # create item
    @route.post("new",response=ItemSchema, auth=JWTAuth())
    def create(self, request, data: ItemSchemaIn, files: File[list[UploadedFile]]):
        item = Item(**data.dict())
        item.save()
        # create images
        images = [ItemImage(image=file, item=item) for file in files]
        imgs = ItemImage.objects.bulk_create(images)
        di = imgs.first()
        di.coverImage = True
        di.save()
        return item
    
    # set cover image
    @route.get("{id}/set-ci/{imageId}", auth=JWTAuth())
    def set_cover_image(self, request, id: str, imageId: int):
        image = ItemImage.objects.get(id=imageId, item_id=id)
        image.coverImage = True
        image.save()
        return

    # update details
    @route.put("{str:id}/update", response=ItemSchema, auth=JWTAuth())
    def update(self, request, id, data: ItemSchema):
        item = get_object_or_404(Item, id=id)
        for attr, value in data.dict(exclude_unset=True).items():
            setattr(item, attr, value)
        item.save()
        return item

    # create pricing
    @route.post("{str:id}/create-pricing", response=List[PricingSchema], auth=JWTAuth())
    def create_pricing(self, request, id, data: List[PricingSchemaIn]):
        prs =[ Pricing(**dt.dict()) for dt in data]
        prices = Pricing.objects.bulk_create(prs)
        return prices


    # update pricing
    @route.put("{str:id}/update-pricing/{pricingId}", response=PricingSchema, auth=JWTAuth())
    def update_pricing(self, request, id, pricingId: int, data: PricingSchema):
        pricing = get_object_or_404(Pricing, id=pricingId, item_id=id)
        for attr, value in data.dict(exclude_unset=True).items():
            setattr(pricing, attr, value)
        pricing.save()
        return pricing

    # add item images
    @route.post("{str:id}/add-images", response=List[ItemImageSchema], auth=JWTAuth())
    def add_images(self, request, files: File[list[UploadedFile]]):
        item = get_object_or_404(Item, id=id)
        images = [ItemImage(image=file, item=item) for file in files]
        imgs = ItemImage.objects.bulk_create(images)
        return imgs

    # delete item image
    @route.put("{str:id}/delete-image/{imageId}", auth=JWTAuth())
    def remove_image(self, request, id, imageId: int):
        image = get_object_or_404(ItemImage, id=imageId, item_id=id)
        if image.coverImage:
            return 403, {"detail": "Select another picture to be cover image then delete."}
        
        image.delete()
        return 

    # delete item
    @route.put("{str:id}/delete", auth=JWTAuth())
    def remove(self, request, id):
        item = get_object_or_404(Item, id=id)
        item.delete()
        return 

    """ NON Auth APIs """
    # list items (filtering by: model and brand name, type, engine size)
    @route.get("list", response=List[ItemSchema])
    def items(self, request):
        items = Item.objects.all()
        return items



api.register_controllers(ItemAPI)

""" Order Related APIs """
@api_controller("order/", tags=["Order"], auth=JWTAuth())
class OrderAPI:
    # create
    @route.post("new")
    def create(self, request, data, files):
        return
    # update
    # delete

api.register_controllers(OrderAPI)