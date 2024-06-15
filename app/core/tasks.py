import logging
from huey import crontab
from huey.contrib.djhuey import db_periodic_task, db_task
from .emails import email_auth_token, email_shop_membership_join_toke
from .utils import gen_auth_token

logger = logging.getLogger(__name__)

@db_task()
def send_email_auth_token(user, type):
    try:
        uat = gen_auth_token(user, type)
        email_auth_token(uat)
    except Exception as e:
        logger.error(e)

# @db_task()
# def send_email_shop_membership_join_token(token, email_to):
#     try:
#         email_shop_membership_join_toke(token, email_to)
#     except Exception as e:
#         logger.error(e)