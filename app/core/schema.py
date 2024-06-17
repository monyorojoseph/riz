from datetime import date
from typing import Optional, Type
from ninja.orm import create_schema
from ninja import Schema, ModelSchema
from .models import User

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
