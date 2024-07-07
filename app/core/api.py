from typing import List
from django.shortcuts import get_object_or_404
from django.contrib.auth import authenticate
from django.core.files.storage import FileSystemStorage
from django.contrib.contenttypes.models import ContentType
from ninja import NinjaAPI, Router, Form, UploadedFile, File
from ninja_extra import api_controller, route
from ninja_jwt.authentication import JWTAuth
from ninja.orm import create_schema
from ninja_jwt.controller import NinjaJWTDefaultController
from ninja_extra import NinjaExtraAPI
from ninja_jwt.authentication import JWTAuth
from ninja_jwt.tokens import RefreshToken
from ninja.responses import codes_4xx

# from .utils import gen_shop_membeship_join_token
from .models import LandVehicle, Pricing, User, UserAuthToken, UserSetting, UserVerification, Vehicle, VehicleBrand, VehicleImage, VehicleModel, VehicleRules, VehicleVerification
from .schema import Error, LandVehicleShema, LandVehicleShemaIn, LogoutSchema, MyTokenObtainPairOutSchema, OverviewMessage, PricingSchema, PricingSchemaIn, SlimUserSchema, UpdateUserSettingSchema \
    ,UserSchema, UpdateUserSchema, UserSettingSchema, UserVerficationSchema, VehicleBrandSchema, VehicleImageSchema, VehicleModelSchema, VehicleRulesSchema, VehicleRulesSchemaIn, VehicleSchema, VehicleSchemaIn, VehicleVerificationSchema 
from .tasks import send_email_auth_token


STORAGE = FileSystemStorage()
api = NinjaExtraAPI()

""" AUTH Related APIs """
@api_controller("auth/", tags=['Auth'])
class AuthAPI:
    # JWT Token
    @route.post("token", response={200: MyTokenObtainPairOutSchema, codes_4xx: Error})
    def jwt_tokens(self, request, data: create_schema(UserAuthToken, fields=['token']) ):
        uat = UserAuthToken.objects.get(token = data.dict()['token'])
        if uat.is_valid:
            user = uat.user
            if uat.type == UserAuthToken.REGISTER or uat.type == UserAuthToken.EMAIL_VERIFY:
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

    # verify email
    # logout    # Login
    @route.post("logout")
    def logout(self, request, data: LogoutSchema):
        try:
            print(data.access)
            token = RefreshToken(data.access)
            token.blacklist()
            return 200
        except Exception as e:
            return 403


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
    

    # delete account
    @route.delete("delete")
    def remove(self, request):
        user = request.user
        user.delete()
        return 200
     
    # user listed vehicles
    @route.get("vehicles", response=List[VehicleSchema])
    def my_listed_vehicles(self, request):
        queryset = request.user.vehicles.all()
        return queryset
           
api.register_controllers(UserAPI)

@api_controller("user-verification/", tags=["User Verification"], auth= JWTAuth())
class UserVerificationAPI:
    # id verification
    @route.post("identity", response=UserVerficationSchema)
    def identity_verification(self, request, file: UploadedFile = File(...)):
        user = request.user
        id_img = STORAGE.save(file.name, file)
        # TODO process the image
        return user
    
    # dl verification
    @route.post("driving-license", response=UserVerficationSchema)
    def driving_license_verification(self, request, file: UploadedFile = File(...)):
        user = request.user
        id_img = STORAGE.save(file.name, file)
        # TODO process the image
        return user
    
    # user verification details
    @route.post("{str:user_id}", response=UserVerficationSchema)
    def get_user_verification_details(self, request, user_id):
        user_verification = UserVerification.objects.get(user_id=user_id)
        return user_verification

api.register_controllers(UserVerificationAPI)

@api_controller("user-settings/", tags=["User Setting"], auth= JWTAuth())
class UserSettingsAPI: 
    # get settings
    @route.get(path="", response=UserSettingSchema)
    def details(self, request):
        return request.user.usersetting
    
    # update setting
    @route.put(path="update", response=UserSettingSchema)
    def change(self, request, data: UpdateUserSettingSchema):
        print(data)
        usersetting = request.user.usersetting
        for attr, value in data.dict(exclude_unset=True).items():
            if value is not None:
                setattr(usersetting, attr, value)
        usersetting.save()
        return usersetting

api.register_controllers(UserSettingsAPI)


""" BRAND & MODEL APIs """
@api_controller("brand/", tags=["Brand and Models"])
class BrandModelAPI:
    # brands
    @route.get("all", response=List[VehicleBrandSchema])
    def brands(self, request):
        brands = VehicleBrand.objects.all()
        return brands
    
    # models
    @route.get("models", response=List[VehicleModelSchema])
    def models(self, request, brandId):
        models = VehicleModel.objects.filter(brand_id=brandId)
        return models

api.register_controllers(BrandModelAPI)

""" VEHICLE Related APIs """
@api_controller("vehicle/", tags=["Vehicle"])
class VehicleAPI:
    # vehicle details
    @route.get("{str:id}/details", response=VehicleSchema)
    def details(self, request, id):
        vehicle = Vehicle.objects.get(id=id)
        return vehicle
    
    # create 
    @route.post(path="create", response=VehicleSchema, auth= JWTAuth())
    def create(self, request, data: VehicleSchemaIn):
        vehicle = Vehicle.objects.create(**data.dict())
        return vehicle

    # update details
    @route.put("{str:id}/update", response=VehicleSchema, auth=JWTAuth())
    def update(self, request, id, data: VehicleSchemaIn):
        vehicle = Vehicle.objects.get(id=id)
        for attr, value in data.dict(exclude_unset=True).items():
            setattr(vehicle, attr, value)
        vehicle.save()
        return vehicle 
    
    # enable display
    @route.get("{str:id}/enable-display", response={200: VehicleSchema, codes_4xx: Error }, auth=JWTAuth())
    def enable_display(self, request, id):
        vehicle = Vehicle.objects.prefetch_related("images", "prices").get(id=id)
        # user is verified
        user = request.user
        if not user.verified:
            return 400, {"detail": "You need to be verified first"}

        # vehicle has images
        if vehicle.images.count() < 3:            
            return 400, {"detail": "You need to post atleast 2 pictures"}

        # vehicle has prices
        if vehicle.prices.count() == 0:            
            return 400, {"detail": "You need to create pricing for your vehicle"}

        # TODO vehicle rules to clients
        # vehicle has rules
        vehicle.display = True
        vehicle.save()
        return vehicle

    # overview or verification to display
    @route.get("{str:id}/verification-overview", response=List[OverviewMessage], auth=JWTAuth())
    def verification_overview(self, request, id):
        vehicle = Vehicle.objects.prefetch_related("images").get(id=id)
        data = []

        # user is verified
        user = request.user
        userStageData = {"stage": "user", "message": "User Account Not Verified", "passed": False }
        if user.verified:
            userStageData['message'] = "User Account Verified"
            userStageData['passed'] = True
        data.append(userStageData)

        # details
        contentStageData = {"stage": "details", "message": "You have not created vehicle details", "passed": False }
        if vehicle.contentId and vehicle.contentId:
            contentStageData['message'] = "Vehicle details are provided"
            contentStageData['passed'] = True
        data.append(contentStageData)

        # vehicle has images
        imagesStageData = {"stage": "images", "message": "Your vehicle needs images to attract clients", "passed": False }
        if vehicle.images.count() >= 3:
            imagesStageData["message"] = "You have posted vehicle images"
            imagesStageData["passed"] = True
        data.append(imagesStageData)

        # vehicle has prices
        pricingStageData = {"stage": "rates", "message": "You need to have atleast one pricing Structure.", "passed": False }
        if vehicle.prices.count() > 0:
            pricingStageData["message"] = "You have added pricing structure"
            pricingStageData["passed"] = True
        data.append(pricingStageData)

        # TODO vehicle rules to clients
        # vehicle has rules
        rulesStageData = {"stage": "rules", "message": "You need to have provide rules for who can rent your car", "passed": False }
        data.append(rulesStageData)

        return data


api.register_controllers(VehicleAPI)

# vehicle images
@api_controller("vehicle-images/", tags=["Vehicle Images"])
class VehicleImagesAPI:
    # create vehicle images
    @route.post(path="{str:id}/create", response=VehicleSchema, auth=JWTAuth())
    def create_vehicle_images(self, request, id, files: File[list[UploadedFile]]):
        vehicle = Vehicle.objects.get(id=id)
        imgs = [ VehicleImage(vehicle=vehicle, image=file) for file in files ]
        VehicleImage.objects.bulk_create(imgs)
        return vehicle
    
    # list vehicle images
    @route.get("{str:id}", response=List[VehicleImageSchema])
    def vehicle_images(self, request, id):
        images = VehicleImage.objects.filter(vehicle_id=id)
        return images
    
api.register_controllers(VehicleImagesAPI)

# vehicle pricing
@api_controller("vehicle-pricing/", tags=["Vehicle Pricing"])
class VehiclePricingAPI:
    # create pricing
    @route.post("create", response=PricingSchema, auth=JWTAuth())
    def create_pricing(self, request, data: PricingSchemaIn):
        pricing = Pricing.objects.create(**data.dict())
        return pricing
    
    # list pricing
    @route.get("{str:vehicle_id}/all", response=List[PricingSchema])
    def vehicle_pricings(self, request, vehicle_id):
        pricings = Pricing.objects.filter(vehicle_id=vehicle_id)
        return pricings
    
    # update
    @route.put("{str:id}", response=PricingSchema, auth=JWTAuth())
    def update_vehicle_pricing(self, request, id, data: PricingSchemaIn):
        pricing = Pricing.objects.get(id=id)
        for attr, value in data.dict(exclude_unset=True).items():
            setattr(pricing, attr, value)
        pricing.save()
        return pricing
    
    # remove
    @route.delete("{str:id}")
    def remove_vehicle_pricing(self, request, id):
        pricing = Pricing.objects.get(id=id)
        pricing.delete()
        return 200

api.register_controllers(VehiclePricingAPI)
    

# vehicle rules
@api_controller("vehicle-rules/", tags=["Vehicle Rules"])
class VehicleRulesAPI:
    # get pricing
    @route.get("{str:vehicle_id}", response=VehicleRulesSchema)
    def get_vehicle_rules(self, request, vehicle_id):
        rules = VehicleRules.objects.get(vehicle_id=vehicle_id)
        return rules
    
    # update pricing
    @route.put("{str:id}/update", response=VehicleRulesSchema, auth=JWTAuth())
    def update_vehicle_rules(self, request, id, data: VehicleRulesSchemaIn):
        rules = VehicleRules.objects.get(id=id)
        for attr, value in data.dict(exclude_unset=True).items():
            setattr(rules, attr, value)
        rules.save()
        return rules

api.register_controllers(VehicleRulesAPI)

# vehicle verification
@api_controller("vehicle-verification/", tags=["Vehicle Verification"])
class VehicleVerificationAPI:
    # get details
    @route.get("{str:vehicle_id}", response=VehicleVerificationSchema)
    def get_vehicle_verification(self, request, vehicle_id):
        vehicle_verification = VehicleVerification.objects.get(vehicle_id=vehicle_id)
        return vehicle_verification
    

    # upload ownership docs / prove of ownership
    @route.post("{str:id}/prove-ownership", response=VehicleVerificationSchema, auth=JWTAuth())
    def prove_ownership(self, request, id, file):
        vehicle_verification = VehicleVerification.objects.get(id=id)
        # TODO check if documents are valid
        return vehicle_verification

    # upload inspection docs / prove of road safety
    @route.post("{str:id}/road-safety-inspection", response=VehicleVerificationSchema, auth=JWTAuth())
    def road_safety_inspection(self, request, id, file):
        vehicle_verification = VehicleVerification.objects.get(id=id)
        # TODO check if documents are valid
        return vehicle_verification

api.register_controllers(VehicleVerificationAPI)

# land vehicle
@api_controller("land-vehicle/", tags=["Land Vehicle"], auth=JWTAuth())
class LandVehicleAPI:
    # create
    @route.post("{str:vehicleId}/create", response=LandVehicleShema)
    def create(self, request, vehicleId, data: LandVehicleShemaIn):
        landvehicle = LandVehicle.objects.create(**data.dict())

        vehicle = Vehicle.objects.get(id=vehicleId)
        vehicle.contentObject = ContentType.objects.get_for_model(landvehicle)
        vehicle.contentId = landvehicle.id
        vehicle.save()
        return landvehicle
    
    # update    
    @route.put("{str:id}/update", response=LandVehicleShema, auth=JWTAuth())
    def update(self, request, id, data: LandVehicleShemaIn):
        landvehicle = LandVehicle.objects.get(id=id)
        for attr, value in data.dict(exclude_unset=True).items():
            setattr(landvehicle, attr, value)
        landvehicle.save()
        return landvehicle 
    

    # details
    @route.get("{str:id}/details", response=LandVehicleShema)
    def details(self, request, id):
        landvehicle = LandVehicle.objects.get(id=id)
        return landvehicle


api.register_controllers(LandVehicleAPI)

# """ SHOP Related APIs """
# @api_controller("shop/", tags=["Shop"])
# class ShopAPI:
#     """ NON Auth APIs """
#     # create shop
#     @route.post("new", response=ShopSchema, auth=JWTAuth())
#     def create(self, request, data: ShopSchemaIn, file: UploadedFile = File(...)):
#         shop = Shop(**data.dict())
#         shop.coverImage.save(file.name, file)
#         # make user the owner
#         sm = ShopMembership.objects.create(user=request.user, shop=shop, role=ShopMembershipRole.OWNER)
#         return shop
    
#     # update shop
#     @route.put("{str:id}/update", response=ShopSchema, auth=JWTAuth())
#     def update(self, request, id, data:ShopSchema ):
#         shop = get_object_or_404(Shop, id=id)
#         for attr, value in data.dict(exclude_unset=True).items():
#             setattr(shop, attr, value)
#         shop.save()
#         return shop
    
#     # upload shop cover image
#     @route.post("{str:id}/upload-ci", response=ShopSchema, auth=JWTAuth())
#     def upload_cover_image(self, request, id, file: UploadedFile = File(...)):
#         shop = get_object_or_404(Shop, id=id)
#         shop.coverImage.save(file.name, file)
#         return shop
      
#     # create add staff code
#     @route.post('{str:id}/join-token', response=create_schema(ShopMembershipToken, fields=['token', 'validTill']), auth=JWTAuth())
#     def join_token(self, request, id, data: create_schema(User, fields=['email'])):
#         email_to = data.dict()['email']
#         shop = get_object_or_404(Shop, id=id)
#         token = gen_shop_membeship_join_token(shop=shop, user=request.user)
#         send_email_shop_membership_join_token(token, email_to)
#         return token
    
#     # staff join using code
#     @route.post('join', response={200: create_schema(ShopMembership, fields=['role', 'shop', 'role']), codes_4xx: Error}, auth=JWTAuth())
#     def join(self, request, data: create_schema(ShopMembershipToken, fields=['token'])):
#         token = ShopMembershipToken.objects.get(token=data.dict()['token'])
#         if token.is_valid:
#             sm = ShopMembership.objects.create(user=request.user, shop=token.shop, role=token.role)
#             token.user =request.user
#             token.valid = False
#             token.save()
#             return sm
#         return 403, {"detail": "Join token has expired"}

#     # list staff
#     @route.get("{str:id}/staff", response=List[ShopMembershipSchema], auth=JWTAuth())
#     def staff(self, request, id):
#         memberships = ShopMembership.objects.filter(shop_id=id)
#         return memberships
    
#     # transactions
#     @route.get("{str:id}/transactions", response=List[TransactionSchema] ,auth=JWTAuth())
#     def transactions(self, request, id):
#         queryset = Transaction.objects.filter(
#             sentFromObject=ContentType.objects.get_for_model(Shop), sentFromObjectId=id,
#             sentToObject=ContentType.objects.get_for_model(Shop), sentToObjectId=id)
#         return queryset
    
#     # wallet and last 5 transactions
#     @route.get("{str:id}/wallet", response=ShopWalletSchema)
#     def wallet(self, request, id):        
#         wallet = Wallet.objects.get(shop_id=id)
#         transactions = Transaction.objects.filter(
#             sentFromObject=ContentType.objects.get_for_model(Shop), sentFromObjectId=id,
#             sentToObject=ContentType.objects.get_for_model(Shop), sentToObjectId=id)[:5]
#         data = {
#             "wallet": wallet,
#             "transactions": transactions
#         }
#         return data
    
#     # rented items
#     @route.get("{str:id}/rented", response=List[OrderOutSchema], auth=JWTAuth())
#     def rented_items(self, request, id):
#         queryset = OrderOut.objects.filter(order__item__shop_id=id, active=True)
#         return queryset
    
#     # deleted
#     @route.delete("{str:id}/delete", auth=JWTAuth())
#     def remove(self, request, id):
#         shop = get_object_or_404(Shop, id=id)
#         shop.delete()
#         return

#     """ NON Auth APIs """
#     # shop details
#     @route.get("{str:id}/details", response=ShopSchema)
#     def details(self, request, id):
#         shop = get_object_or_404(Shop, id=id)
#         return shop

#     # list shop(dealership or whatever) items(cars or whatever)
#     @route.get("{str:id}/items", response=List[ItemSchema])
#     def items(self, request, id):
#         shop = Shop.objects.prefetch_related("items").get(id=id)
#         return shop.items.all()

# api.register_controllers(ShopAPI)

# """ Item Related APIs """
# @api_controller("item/", tags=["Item"])
# class ItemAPI:
#     """ Auth APIs """
#     # create item
#     @route.post("new", response=ItemSchema, auth=JWTAuth())
#     def create(self, request, data: ItemSchemaIn, files: File[list[UploadedFile]]):
#         item = Item(**data.dict())
#         item.save()
#         # create images
#         images = [ItemImage(image=file, item=item) for file in files]
#         ItemImage.objects.bulk_create(images)
#         di = item.images.first()
#         di.coverImage = True
#         di.save()
#         return item
    
#     # set cover image
#     @route.get("{id}/set-ci/{imageId}", auth=JWTAuth())
#     def set_cover_image(self, request, id: str, imageId: int):
#         image = ItemImage.objects.get(id=imageId, item_id=id)
#         image.coverImage = True
#         image.save()
#         return

#     # update details
#     @route.put("{str:id}/update", response=ItemSchema, auth=JWTAuth())
#     def update(self, request, id, data: ItemSchema):
#         item = get_object_or_404(Item, id=id)
#         for attr, value in data.dict(exclude_unset=True).items():
#             setattr(item, attr, value)
#         item.save()
#         return item

#     # create pricing
#     @route.post("{str:id}/create-pricing", response=List[PricingSchema], auth=JWTAuth())
#     def create_pricing(self, request, id, data: List[PricingSchemaIn]):
#         prs =[ Pricing(**dt.dict()) for dt in data]
#         prices = Pricing.objects.bulk_create(prs)
#         return prices

#     # update pricing
#     @route.put("{str:id}/update-pricing/{pricingId}", response=PricingSchema, auth=JWTAuth())
#     def update_pricing(self, request, id, pricingId: int, data: PricingSchema):
#         pricing = get_object_or_404(Pricing, id=pricingId, item_id=id)
#         for attr, value in data.dict(exclude_unset=True).items():
#             setattr(pricing, attr, value)
#         pricing.save()
#         return pricing
    
#     # delete pricing
#     @route.delete("{str:id}/delete-pricing/{pricingId}",  auth=JWTAuth())
#     def remove_pricing(self, request, id, pricingId: int ):
#         pricing = get_object_or_404(Pricing, id=pricingId, item_id=id)
#         pricing.delete()
#         return

#     # add item images
#     @route.post("{str:id}/add-images", response=List[ItemImageSchema], auth=JWTAuth())
#     def add_images(self, request, id, files: File[list[UploadedFile]]):
#         item = get_object_or_404(Item, id=id)
#         images = [ItemImage(image=file, item=item) for file in files]
#         imgs = ItemImage.objects.bulk_create(images)
#         return imgs

#     # delete item image
#     @route.delete("{str:id}/delete-image/{imageId}", auth=JWTAuth())
#     def remove_image(self, request, id, imageId: int):
#         image = get_object_or_404(ItemImage, id=imageId, item_id=id)
#         if image.coverImage:
#             return 403, {"detail": "Select another picture to be cover image then delete."}
        
#         image.delete()
#         return 

#     # delete item
#     @route.delete("{str:id}/delete", auth=JWTAuth())
#     def remove(self, request, id):
#         item = get_object_or_404(Item, id=id)
#         item.delete()
#         return 

#     """ NON Auth APIs """
#     # list items (filtering by: model and brand name, type, engine size)
#     @route.get("list", response=List[ItemSchema])
#     def items(self, request):
#         items = Item.objects.all()
#         return items
    
#     @route.get("{str:id}/details", response=ItemSchema)
#     def details(self, request, id):
#         item = get_object_or_404(Item, id=id)
#         return item

# api.register_controllers(ItemAPI)

# """ Order Related APIs """
# @api_controller("order/", tags=["Order"], auth=JWTAuth())
# class OrderAPI:
#     # create
#     @route.post("new", response=OrderSchema)
#     def create(self, request, data: OrderSchemaIn):
#         order = Order.objects.create(**data.dict(), user=request.user)
#         return order
    
#     # update
#     @route.put("{str:id}/update", response=OrderSchema)
#     def update(self, request, id, data: OrderSchema):
#         order = get_object_or_404(Order, id=id)
#         for attr, value in data.dict(exclude_unset=True).items():
#             setattr(order, attr, value)
#         order.save()
#         return order
    
#     # order review

#     # delete
#     @route.delete("{str:id}/ delete")
#     def remove(self, request, id):
#         order = get_object_or_404(Order, id=id)
#         order.delete()
#         return

# api.register_controllers(OrderAPI)

# """ Payment Related APIs"""
# @api_controller("payment/", tags=["Payment"], auth=JWTAuth())
# class PaymentAPI:
#     # make payment
#     pass