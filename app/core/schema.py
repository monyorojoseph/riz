from datetime import date
from typing import Optional, Type
from ninja.orm import create_schema
from ninja import Schema, ModelSchema
from .models import LandVehicle, Pricing, User, UserSetting, UserVerification, Vehicle, VehicleImage, VehicleBrand, VehicleModel, \
    VehicleRules, VehicleVerification

""" User """
SlimUserSchema = create_schema(User, fields=['email', 'fullName', 'id', 'verifiedEmail', 'verified'])
UserSchema = create_schema(User, fields=['id', 'fullName', 'email', 'verifiedEmail', 'phone', 'sex', 'profilePicture', 'verified', 'joinedOn'])
UpdateUserSchema = create_schema(User, fields=['fullName', 'email', 'phone', 'sex'], \
                                optional_fields=['fullName', 'email', 'phone', 'sex'])
class MyTokenObtainPairOutSchema(Schema):
    refresh: str
    access: str
    user: SlimUserSchema

class LogoutSchema(Schema):
    access: str


UserSettingSchema = create_schema(model=UserSetting)
UpdateUserSettingSchema = create_schema(model=UserSetting, fields=['appPurpose', 'currentScreen'], \
                            optional_fields=['appPurpose', 'currentScreen'])

UserVerficationSchema = create_schema(UserVerification)

""" Vehicle """
VehicleBrandSchema = create_schema(model=VehicleBrand)
VehicleModelSchema = create_schema(model=VehicleModel)


VehicleImageSchema = create_schema(model=VehicleImage, fields=['id', 'image', 'coverImage'])
VehicleSchema = create_schema(
    model=Vehicle, 
    fields=['id', 'yom', 'category', 'contentType', 'contentId', 'display',
            'createdOn', 'updatedOn'],
    custom_fields=[
        ('brand', VehicleBrandSchema, None),
        ('model', VehicleModelSchema, None),
        ('images', list[VehicleImageSchema], []),
        ('prices', list[create_schema(Pricing)], []),
        ('seller', Optional[SlimUserSchema], None),
    ])

class VehicleSchemaIn(Schema):
    model_id: str
    brand_id: str
    category: str
    yom: str = None
    display: bool = False
    seller_id: str = None
    # shop_id: str = None


LandVehicleShema = create_schema(model=LandVehicle)
class LandVehicleShemaIn(Schema):
    engineType: str
    engineSize: str
    doors: Optional[int] = None
    passengers: int
    load: int
    fuelType: str
    transmission: str
    drivetrain: Optional[str] = None
    type: str
    mileage: int

class OverviewMessage(Schema):
    stage: str
    message: str
    passed: bool
    

VehicleRulesSchema = create_schema(
    VehicleRules, 
    fields=['id', 'vehicle', 'latePenalty' ,'verifiedUser','verifiedDl']
    )

class VehicleRulesSchemaIn(Schema):
    # deposit: Optional[bool]
    latePenalty: Optional[bool]
    # geographicLimit: Optional[bool]
    verifiedUser: Optional[bool]
    verifiedDl: Optional[bool]
    # prohibitedUses: Optional[dict]

VehicleVerificationSchema = create_schema(VehicleVerification)

""" PRICING """
PricingSchema = create_schema(Pricing)

class PricingSchemaIn(Schema):
    vehicle_id: str
    period: str
    amount: int




# """ Shop """
# class ShopSchemaIn(Schema):
#     name: str
#     located: str = None
#     url: str = None

# ShopSchema = create_schema(Shop, fields=['id', 'name', 'located', 'url', 'coverImage'], optional_fields=['name', 'located', 'url', 'coverImage'])

# ShopMembershipSchema =  create_schema(ShopMembership, fields=['user', 'role', 'joinedOn'], custom_fields=[('user', SlimUserSchema, None)])

# """ Pricing """
# class PricingSchemaIn(Schema):
#     item_id: str
#     type: str
#     period: str
#     amount: int
#     downPaymentAmount: int = None

# PricingSchema = create_schema(Pricing, fields=['id', 'item', 'type', 'period', 'amount', 'downPaymentAmount'],
#                               optional_fields=['item', 'type', 'period', 'amount', 'downPaymentAmount'])


# """ Item """
# ItemImageSchema = create_schema(ItemImage, fields=['id', 'image', 'coverImage'])
# ItemSchema = create_schema(Item, fields=['id', 'modelName', 'brandName', 'yom', 'type', 'detailsObject', 'detailsObjectId'],
#                            optional_fields=['modelName', 'brandName', 'yom', 'type', 'detailsObject', 'detailsObjectId'],
#                            custom_fields=[                                                    
#                             ('images', list[ItemImageSchema], []),
#                             ('shop', Optional[ShopSchema], None),
#                             ('lender', Optional[SlimUserSchema], None),
#                             ('prices', list[PricingSchema], [])
#                            ])       
        
    
# class ItemSchemaIn(Schema):
#     modelName: str
#     brandName: str
#     yom: str
#     type: str
#     lender_id: str = None
#     shop_id: str = None


# """ Order """
# class OrderSchemaIn(Schema):
#     item_id: str
#     type: str
#     stage: str
#     fromDate: date
#     tillDate: date 
#     amount: int
#     downPaymentAmount: int
    
# OrderSchema = create_schema(Order, fields=['item', 'type', 'stage', 'fromDate', 'tillDate', 'amount', 'downPaymentAmount'])

# """ Order out/ rented"""
# OrderOutSchema = create_schema(OrderOut, fields=['order', 'createdOn'],custom_fields=[('order', OrderSchema, None)])

# """ Payment """
# PaymentSchema = create_schema(Payment, fields=['id','method', 'state', 'type', 'amount', 'createdOn'])

# """ Transaction """
# TransactionSchema = create_schema(Transaction, fields=['type', 'amount', 'createdOn'])

# """ Wallet """
# class ShopWalletSchema(Schema):
#     wallet: create_schema(Wallet, fields=['shop', 'balance'])
#     transactions: list[TransactionSchema]
# class UserWalletSchema(Schema):
#     wallet: create_schema(Wallet, fields=['user', 'balance'])
#     transactions: list[TransactionSchema]


class Error(Schema):
    detail: str
