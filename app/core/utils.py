import string
import random
from datetime import timedelta
from django.utils import timezone
from .models import UserAuthToken, Shop, ShopMembershipToken

def gen_token(k=6):
    return ''.join(random.choices(string.ascii_uppercase+string.digits, k=k))

def gen_auth_token(user, type):
    token = gen_token()
    if UserAuthToken.objects.filter(token=token).exists():
        return gen_auth_token(user)
    uat = UserAuthToken.objects.create(token=token, user=user, type=type, 
                                        validTill=timezone.now()+timedelta(minutes=2))
    return uat

def gen_shop_membeship_join_token(shop, user):
    token = gen_token()
    if ShopMembershipToken.objects.filter(token=token).exists():
        return gen_shop_membeship_join_token(shop, user)
    smt = ShopMembershipToken.objects.create(token=token, shop=shop, createdBy=user,
                                            validTill=timezone.now()+timedelta(hours=24))
    return smt

