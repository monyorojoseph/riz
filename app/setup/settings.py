import os
import dj_database_url
from datetime import timedelta
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('SECRET_KEY', "django_insecure-1234567890")

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.environ.get('DEBUG', 1) in [ 'true', 't', True, 'True', 1, '1']

ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', '*').split(' ')


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    "corsheaders",
    'ninja',
    'ninja_extra',
    'ninja_jwt',
    'ninja_jwt.token_blacklist',
    'huey.contrib.djhuey', 
    "django_lifecycle_checks",
    'core'
]

AUTH_USER_MODEL='core.User'

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    "corsheaders.middleware.CorsMiddleware",
    'django.middleware.common.CommonMiddleware',
    "whitenoise.middleware.WhiteNoiseMiddleware",
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'setup.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'setup.wsgi.application'


# Database
# https://docs.djangoproject.com/en/5.0/ref/settings/#databases

# postgres://USER:PASSWORD@HOST:PORT/NAME
DB_URL = os.environ.get("DB_URL", "postgres://riz:riz@localhost:5432/riz")
DATABASES = {
    'default': dj_database_url.config(
        default=DB_URL,
        conn_max_age=600,
        conn_health_checks=True,
    )
}

# Email

EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_HOST = os.environ.get('EMAIL_HOST')
EMAIL_PORT = os.environ.get('EMAIL_PORT')
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD')
EMAIL_USE_SSL = False
EMAIL_USE_TLS= True


# Password validation
# https://docs.djangoproject.com/en/5.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.0/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.0/howto/static-files/

if DEBUG:
    STATIC_URL = 'static/'
    STATIC_ROOT = BASE_DIR / "staticfiles"


    MEDIA_URL = 'media/'
    MEDIA_ROOT =  BASE_DIR / 'media/'
else:
    STORAGE_ACCOUNT_KEY = os.environ.get("STORAGE_ACCOUNT_KEY")
    STORAGE_ACCOUNT_NAME = os.environ.get("STORAGE_ACCOUNT_NAME")

    STORAGES = {
        "default": {
            "BACKEND": "storages.backends.azure_storage.AzureStorage",
            "OPTIONS": {
            "account_key": STORAGE_ACCOUNT_KEY,
            "account_name": STORAGE_ACCOUNT_NAME,
            "azure_container": "rizmedia"
            },
        },
        "staticfiles": {
            "BACKEND": "storages.backends.azure_storage.AzureStorage",
            "OPTIONS": {
            "account_key": STORAGE_ACCOUNT_KEY,
            "account_name": STORAGE_ACCOUNT_NAME,
            "azure_container": "rizstatic"
            },
        },
    }

    STATIC_URL = f'https://{STORAGE_ACCOUNT_NAME}.blob.core.windows.net/'
    STATIC_ROOT = BASE_DIR / "staticfiles"


    MEDIA_URL = f'https://{STORAGE_ACCOUNT_NAME}.blob.core.windows.net/'
    MEDIA_ROOT =  BASE_DIR / 'media/'


# Default primary key field type
# https://docs.djangoproject.com/en/5.0/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


CORS_ALLOW_ALL_ORIGINS=True

NINJA_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=31),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=30),
    'ROTATE_REFRESH_TOKENS': False,
    'BLACKLIST_AFTER_ROTATION': False,
    'UPDATE_LAST_LOGIN': True,

    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'VERIFYING_KEY': None,
    'AUDIENCE': None,
    'ISSUER': None,
    'JWK_URL': None,
    'LEEWAY': 0,

    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
    'USER_AUTHENTICATION_RULE': 'ninja_jwt.authentication.default_user_authentication_rule',

    'AUTH_TOKEN_CLASSES': ('ninja_jwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',
    'TOKEN_USER_CLASS': 'ninja_jwt.models.TokenUser',

    'JTI_CLAIM': 'jti',

    'SLIDING_TOKEN_REFRESH_EXP_CLAIM': 'refresh_exp',
    'SLIDING_TOKEN_LIFETIME': timedelta(minutes=5),
    'SLIDING_TOKEN_REFRESH_LIFETIME': timedelta(days=1),

    # For Controller Schemas
    # FOR OBTAIN PAIR
    'TOKEN_OBTAIN_PAIR_INPUT_SCHEMA': "ninja_jwt.schema.TokenObtainPairInputSchema",
    # 'TOKEN_OBTAIN_PAIR_INPUT_SCHEMA': 'core.jwt_tokens.MyTokenObtainPairInputSchema',    # token pair custom schema
    'TOKEN_OBTAIN_PAIR_REFRESH_INPUT_SCHEMA': "ninja_jwt.schema.TokenRefreshInputSchema",
    # FOR SLIDING TOKEN
    'TOKEN_OBTAIN_SLIDING_INPUT_SCHEMA': "ninja_jwt.schema.TokenObtainSlidingInputSchema",
    'TOKEN_OBTAIN_SLIDING_REFRESH_INPUT_SCHEMA':"ninja_jwt.schema.TokenRefreshSlidingInputSchema",

    'TOKEN_BLACKLIST_INPUT_SCHEMA': "ninja_jwt.schema.TokenBlacklistInputSchema",
    'TOKEN_VERIFY_INPUT_SCHEMA': "ninja_jwt.schema.TokenVerifyInputSchema",
}

REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
REDIS_PORT = os.environ.get('REDIS_PORT', 6379)

REDIS_URL = f'redis://{REDIS_HOST}:{REDIS_PORT}/?db=1' 

HUEY = {
    'huey_class': 'huey.RedisHuey',  # Huey implementation to use.
    'name': 'redis',  # Use db name for huey.
    'results': True,  # Store return values of tasks.
    'store_none': False,  # If a task returns None, do not save to results.
    'immediate': False,  # If DEBUG=True, run synchronously.
    'utc': True,  # Use UTC for all times internally.
    'blocking': True,  # Perform blocking pop rather than poll Redis.
    'connection': {
        'read_timeout': 1,  # If not polling (blocking pop), use timeout.
        'url': REDIS_URL,  # Allow Redis config via a DSN.
    },
    'consumer': {
        'workers': 1,
        'worker_type': 'thread',
        'initial_delay': 0.1,  # Smallest polling interval, same as -d.
        'backoff': 1.15,  # Exponential backoff using this rate, -b.
        'max_delay': 10.0,  # Max possible polling interval, -m.
        'scheduler_interval': 1,  # Check schedule every second, -s.
        'periodic': True,  # Enable crontab feature.
        'check_worker_health': True,  # Enable worker health checks.
        'health_check_interval': 1,  # Check worker health every second.
    },
}

LOG_LEVEL = os.getenv('DJANGO_LOG_LEVEL', 'INFO')
LOG_DIR = os.path.join(BASE_DIR, 'logs')


LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{name} {asctime} {levelname} {message}',
            'style': '{',
            'datefmt': '%W/%d/%Y %H:%M'
        },
        'simple': {
            "()": "coloredlogs.ColoredFormatter",
            'format': '[ {name} ] {levelname} {message}',
            'style': '{',
            
        },
    },
    "filters": {
        "require_debug_true": {
             "()": "django.utils.log.RequireDebugTrue",
        },
        "require_debug_false": {
             "()": "django.utils.log.RequireDebugFalse",
        }
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            "formatter": "simple",
            "filters": [ 'require_debug_true' ]
        },
        # "file": {
        #     "level": "INFO",
        #     "class": "logging.FileHandler",
        #     "filename": f"{LOG_DIR}/info.log",
        #     "formatter": "verbose",
        #     "filters": [ 'require_debug_false' ]
        # }
    },
    'loggers': {
        'django.db': {
            'handlers': ['console'],
            'level': LOG_LEVEL,
            "propagate": False
        },
        'django.request': {
            'handlers': ['console'],
            'level': LOG_LEVEL,
            "propagate": False
        },
        'django.server': {
            'handlers': ['console'],
            'level': LOG_LEVEL,
            "propagate": False
        },
        'django.template': {
            'handlers': ['console'],
            'level': 'INFO',
            "propagate": False
        },
        'core': {            
            'handlers': ['console'],
            'level': LOG_LEVEL,
            "propagate": False            
        }
    }
}