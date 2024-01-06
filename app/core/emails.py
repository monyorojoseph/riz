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