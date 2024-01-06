import uuid
from django.db import models
from django.utils import timezone
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser
from django.core.validators import MaxLengthValidator


class UserManager(BaseUserManager):
    def create_user(self, email, fullName, password=None):
        if not email:
            raise ValueError("Users must have an email address")

        user = self.model(
            email=self.normalize_email(email),
            fullName=fullName,
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, fullName, password=None):
        user = self.create_user(
            email,
            password=password,
            fullName=fullName,
        )
        user.is_admin = True
        user.save(using=self._db)
        return user

class User(AbstractBaseUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    fullName = models.CharField(max_length=200)
    email = models.EmailField(max_length=200, unique=True)
    verifiedEmail = models.BooleanField(default=False)
    phone = models.CharField(max_length=15)

    MALE, FEMALE, NONE = 'ML', 'FML', 'None'
    SEX_CHOICES = [
        (MALE, 'Male'),
        (FEMALE, 'Female'),
        (NONE, "Don't want to identify")
    ]

    sex = models.CharField(default=NONE, choices=SEX_CHOICES)
    profilePicture = models.ImageField(null=True, blank=True, upload_to='profile_picture')
    idImage = models.ImageField(null=True, blank=True, upload_to='id_images')
    idNumber = models.CharField(null=True, blank=True, max_length=15, unique=True)
    verified = models.BooleanField(default=False)
    joinedOn = models.DateTimeField(auto_now_add=True)

    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["fullName"]

    def __str__(self):
        return self.fullName

    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True

    @property
    def is_staff(self):
        return self.is_admin

class TokenBase(models.Model):
    token = models.CharField(unique=True, max_length=8)
    createdOn = models.DateTimeField(auto_now_add=True)
    validFrom = models.DateTimeField(default=timezone.now)
    validTill = models.DateTimeField(default=timezone.now)
    valid = models.BooleanField(default=True)

    class Meta:
        abstract = True

class UserAuthToken(TokenBase):
    user = models.ForeignKey('User', on_delete=models.CASCADE)
    
    LOGIN = 'LN'
    REGISTER = 'RR'

    CHOICES = [
        (LOGIN, "User Login"),
        (REGISTER, "User Registration")
    ]
    type = models.CharField(default=LOGIN, choices=CHOICES, max_length=5)

    @property
    def is_valid(self):
        now = timezone.now()
        return self.valid and (self.validFrom < now and self.validTill > now)

class ShopMembership(models.Model):
    user = models.ForeignKey('User', related_name='shops', on_delete=models.CASCADE)
    shop = models.ForeignKey('Shop', related_name='staff', on_delete=models.CASCADE)

    OWNER = "OR"
    ADMIN = "AN"

    ROLE_CHOICES = [
        (OWNER, "Shop Owner"),
        (ADMIN, "Shop Admin")
    ]

    role = models.CharField(default=OWNER, choices=ROLE_CHOICES, max_length=5)
    joinedOn = models.DateTimeField(auto_now_add=True)

class Shop(models.Model):
    name = models.CharField(max_length=100)
    located = models.CharField(max_length=100)
    url = models.URLField(blank=True, null=True)
    coverImage = models.ImageField(null=True, blank=True, upload_to='shop_cover_imgs')
    createdOn = models.DateTimeField(auto_now_add=True)
    slug = models.SlugField(unique=True, max_length=100)

    def __str__(self) -> str:
        return self.name

class Item(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    modelName = models.CharField(max_length=200)
    brandName = models.CharField(max_length=200)
    yom = models.CharField(max_length=6, null=True)
    lender = models.ForeignKey('User', related_name='items', on_delete=models.SET_NULL, null=True, blank=True)
    shop = models.ForeignKey('Shop', related_name='items', on_delete=models.SET_NULL, null=True, blank=True)

    detailsObject = models.ForeignKey(ContentType, on_delete=models.CASCADE, null=True)
    detailsObjectId = models.PositiveIntegerField(null=True)
    detals = GenericForeignKey("detailsObject", "detailsObjectId")
    createdOn = models.DateTimeField(auto_now_add=True)

    MOTOR_CYCLE = 'MC'
    VEHICLE = 'VE'
    LORRY = 'LY'
    TRACTOR = 'TR'

    TYPE_CHOICES = [
        (MOTOR_CYCLE, "Motor cycle"),
        (VEHICLE, "Just a regular vehicle sized car, suv, van etc"),
        (LORRY, "Big vehicle"),
        (TRACTOR, "Tractor")
    ]

    type = models.CharField(default=VEHICLE, choices=TYPE_CHOICES, max_length=3)

    def __str__(self) -> str:
        return f"{self.brandName} {self.modelName}" 

class Pricing(models.Model):
    item = models.OneToOneField('Item', related_name='prices', on_delete=models.CASCADE)

    SHORT_TERM = 'SM'
    LONG_TERM = 'LM'

    TYPE_CHOICES = [
        (SHORT_TERM, "Leasing for a few days"),
        (LONG_TERM, "Leasing for more than a year")
    ]

    type = models.CharField(default=SHORT_TERM, choices=TYPE_CHOICES, max_length=5)

    HOUR = 'HR'
    DAY = 'DY'
    MONTH = 'MH'

    PERIOD_CHOICES = [
        (HOUR, "Per hour pricing rate"),
        (DAY, "Per day pricing rate"),
        (MONTH, "Per month pricing rate")
    ]

    period = models.CharField(default=DAY, choices=PERIOD_CHOICES, max_length=5)
    amount = models.PositiveIntegerField()
    downPaymentAmount = models.PositiveIntegerField(null=True, blank=True)

class ItemImage(models.Model):
    item = models.ForeignKey('Item', related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(upload_to='item_images')
    coverImage = models.BooleanField(default=False)

# class VehicleBase(models.Model):

#     COMBUSTION = 'CN'
#     HYBRID = 'HD'
#     ELECTRIC = 'EC'

#     ENGINE_TYPE_CHOICES = [
#         (COMBUSTION, "Combustion engine"),
#         (HYBRID, "Hybrid engine"),
#         (ELECTRIC, "Electric engine")
#     ]

#     engineType = models.CharField(default=COMBUSTION, choices=ENGINE_TYPE_CHOICES, default=5)
#     engineSize = models.CharField()
#     # doors = models.PositiveIntegerField()

#     class Meta:
#         abstract =True

# class Vehicle(VehicleBase):
#     pass

# class Lorry(VehicleBase):
#     load = models.PositiveIntegerField()

# class Tractor(VehicleBase):
#     load = models.PositiveIntegerField()


class Order(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey('User', related_name='orders', on_delete=models.CASCADE)
    item = models.OneToOneField('Item', related_name='orders', on_delete=models.CASCADE)

    CART = 'CT'
    BOOK = 'BK'
    CHECK_OUT = 'CO'
    PAID = 'PD'

    STAGE_CHOICES = [
        (CART, "Item added to cart"),
        (BOOK, "Item has been booked"),
        (CHECK_OUT, "Item is on check out"),
        (PAID, "Item has been paid for")
    ]

    SHORT_TERM = 'SM'
    LONG_TERM = 'LM'

    TYPE_CHOICES = [
        (SHORT_TERM, "Leasing for a few days"),
        (LONG_TERM, "Leasing for more than a year")
    ]

    type = models.CharField(default=SHORT_TERM, choices=TYPE_CHOICES, max_length=5)

    stage = models.CharField(default=CART, choices=STAGE_CHOICES, max_length=5)
    createOn = models.DateTimeField(auto_now_add=True)
    fromDate = models.DateTimeField(default=timezone.now)
    tillDate = models.DateTimeField(null=True, blank=True)
    amount = models.PositiveIntegerField()
    downPaymentAmount = models.PositiveIntegerField(null=True, blank=True)

class Rating(models.Model):
    order = models.OneToOneField('Order', related_name='rating', on_delete=models.CASCADE)
    item = models.PositiveIntegerField(default=0, validators = [MaxLengthValidator(5)])
    lender = models.PositiveIntegerField(default=0, validators = [MaxLengthValidator(5)])
    borrower = models.PositiveIntegerField(default=0, validators = [MaxLengthValidator(5)])

class Payment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    order = models.ForeignKey('Order', related_name='payment', on_delete=models.CASCADE)

    CASH = 'CH'
    MPESA = 'MA'
    CARD = 'CD'

    METHOD_CHOICES = [
        (MPESA, "M-Pesa"),
        (CASH, "Cash"),
        (CARD, "Credit / Debit card")
    ]
    method = models.CharField(default=MPESA, choices=METHOD_CHOICES, max_length=5)

    PENDING = 'PG'
    APPROVED = 'AD'

    STATE_CHOICES = [
        (PENDING, "Payment got initiated waiting for approvale"),
        (APPROVED, "Payment has been successfully"),

    ]
    state = models.CharField(default=PENDING, choices=STATE_CHOICES, max_length=5)

    LEASE_PAYMENT = 'LP'
    DOWN_PAYMENT = 'DP'

    TYPE_CHOICES = [
        (LEASE_PAYMENT, "Normal payment"),
        (DOWN_PAYMENT, "Down payment long term lease")
    ]
    type = models.CharField(default=LEASE_PAYMENT, choices=TYPE_CHOICES, max_length=5)
    amount = models.PositiveIntegerField()
    createdOn = models.DateTimeField(auto_now_add=True)

class Refund(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    amount = models.PositiveIntegerField()
    payment = models.OneToOneField('Payment', related_name='refund', on_delete=models.CASCADE)

class Wallet(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField('User', related_name='wallet', on_delete=models.SET_NULL, null=True, blank=True)
    shop = models.ForeignKey('Shop', related_name='wallet', on_delete=models.SET_NULL, null=True, blank=True)
    balance = models.PositiveIntegerField()

class Transaction(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    PAYMENT = 'PT'
    REFUND = 'RD'
    WITHDRAWAL = 'WL'

    TYPE_CHOICES = [
        (PAYMENT, "Borrower paid the lender"),
        (REFUND, "Lender refunded borrower their money"),
        (WITHDRAWAL, "Shop or user withdrew their money")
    ]

    type = models.CharField(default=PAYMENT, choices=TYPE_CHOICES, max_length=5)

    sentFromObject = models.ForeignKey(ContentType, on_delete=models.CASCADE, related_name="transactionsfrom", null=True)
    sentFromObjectId = models.CharField(null=True)
    sentFrom = GenericForeignKey("sentFromObject", "sentFromObjectId")

    sentToObject = models.ForeignKey(ContentType, on_delete=models.CASCADE, related_name="transactionsto", null=True)
    sentToObjectId = models.CharField(null=True)
    sentTo = GenericForeignKey("sentToObject", "sentToObjectId")

    amount = models.PositiveIntegerField()
    createdOn = models.DateTimeField(auto_now_add=True)

    payment = models.ForeignKey('Payment', related_name='transactions', on_delete=models.SET_NULL, null=True, blank=True)