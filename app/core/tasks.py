from huey import crontab
from huey.contrib.djhuey import db_periodic_task, db_task
from .emails import email_auth_token
from .utils import gen_auth_token

@db_task()
def send_email_auth_token(user, type):
    uat = gen_auth_token(user, type)
    email_auth_token(uat)