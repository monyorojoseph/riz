from django.conf import settings
from django.core.mail import send_mail
from django.core.mail import EmailMultiAlternatives

def email_auth_token(token):
    send_mail(
        "Auth Token Code",
        f"Your code is {token.token}",
        settings.EMAIL_HOST_USER,
        [token.user.email],
        fail_silently=False,
    )

def email_shop_membership_join_toke(token, email_to):
    send_mail(
        f"{token.shop.name} join token",
        f"{token.shop.name} join token is {token.token} user it before {token.validTill}",
        settings.EMAIL_HOST_USER,
        [email_to],
        fail_silently=False,
    )
