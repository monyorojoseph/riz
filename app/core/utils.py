import string
import random
from datetime import timedelta
from django.utils import timezone
from .models import UserAuthToken

def gen_token(k=6):
    return ''.join(random.choices(string.ascii_uppercase+string.digits, k=k))

def gen_auth_token(user, type):
    token = gen_token()
    if UserAuthToken.objects.filter(token=token).exists():
        return gen_auth_token(user)
    uat = UserAuthToken.objects.create(token=token, user=user, type=type, 
                                        validTill=timezone.now()+timedelta(minutes=2))
    return uat