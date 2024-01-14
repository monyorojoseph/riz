# Generated by Django 5.0.1 on 2024-01-14 11:39

import django.core.validators
import django.db.models.deletion
import django.utils.timezone
import django_lifecycle.mixins
import uuid
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('fullName', models.CharField(max_length=200)),
                ('email', models.EmailField(max_length=200, unique=True)),
                ('verifiedEmail', models.BooleanField(default=False)),
                ('phone', models.CharField(max_length=15)),
                ('sex', models.CharField(choices=[('ML', 'Male'), ('FML', 'Female'), ('None', "Don't want to identify")], default='None')),
                ('profilePicture', models.ImageField(blank=True, null=True, upload_to='profile_picture')),
                ('idImage', models.ImageField(blank=True, null=True, upload_to='id_images')),
                ('idNumber', models.CharField(blank=True, max_length=15, null=True, unique=True)),
                ('verified', models.BooleanField(default=False)),
                ('joinedOn', models.DateTimeField(auto_now_add=True)),
                ('is_active', models.BooleanField(default=True)),
                ('is_admin', models.BooleanField(default=False)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Shop',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=100)),
                ('located', models.CharField(max_length=100)),
                ('url', models.URLField(blank=True, null=True)),
                ('coverImage', models.ImageField(blank=True, null=True, upload_to='shop_cover_imgs')),
                ('createdOn', models.DateTimeField(auto_now_add=True)),
            ],
            bases=(django_lifecycle.mixins.LifecycleModelMixin, models.Model),
        ),
        migrations.CreateModel(
            name='Item',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('modelName', models.CharField(max_length=200)),
                ('brandName', models.CharField(max_length=200)),
                ('yom', models.CharField(max_length=6, null=True)),
                ('detailsObjectId', models.PositiveIntegerField(null=True)),
                ('createdOn', models.DateTimeField(auto_now_add=True)),
                ('type', models.CharField(choices=[('BCE', 'Bicycle'), ('DB', 'Dirty Bike'), ('MC', 'Motor Cycle'), ('SC', 'Car'), ('HB', 'Hatch back'), ('CTE', 'Convertible'), ('CC', 'Coupe'), ('SSC', 'Sorts Car'), ('SUV', 'SUV'), ('PP', 'Pick up'), ('DCT', 'Double Cab Truck'), ('LY', 'Lorry'), ('TR', 'Tractor')], default='SC', max_length=3)),
                ('detailsObject', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='contenttypes.contenttype')),
                ('lender', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='items', to=settings.AUTH_USER_MODEL)),
                ('shop', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='items', to='core.shop')),
            ],
        ),
        migrations.CreateModel(
            name='ItemImage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.ImageField(upload_to='item_images')),
                ('coverImage', models.BooleanField(default=False)),
                ('item', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='images', to='core.item')),
            ],
        ),
        migrations.CreateModel(
            name='Order',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('type', models.CharField(choices=[('SM', 'Leasing for a few days'), ('LM', 'Leasing for more than a year')], default='SM', max_length=5)),
                ('stage', models.CharField(choices=[('CT', 'Item added to cart'), ('BK', 'Item has been booked'), ('CO', 'Item is on check out'), ('PD', 'Item has been paid for')], default='CT', max_length=5)),
                ('createOn', models.DateTimeField(auto_now_add=True)),
                ('fromDate', models.DateTimeField(default=django.utils.timezone.now)),
                ('tillDate', models.DateTimeField(blank=True, null=True)),
                ('amount', models.PositiveIntegerField()),
                ('downPaymentAmount', models.PositiveIntegerField(blank=True, null=True)),
                ('item', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='orders', to='core.item')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='orders', to=settings.AUTH_USER_MODEL)),
            ],
            bases=(django_lifecycle.mixins.LifecycleModelMixin, models.Model),
        ),
        migrations.CreateModel(
            name='OrderOut',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('active', models.BooleanField(default=True)),
                ('order', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='core.order')),
            ],
        ),
        migrations.CreateModel(
            name='Payment',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('method', models.CharField(choices=[('MA', 'M-Pesa'), ('CH', 'Cash'), ('CD', 'Credit / Debit card')], default='MA', max_length=5)),
                ('state', models.CharField(choices=[('PG', 'Payment got initiated waiting for approvale'), ('AD', 'Payment has been successfully')], default='PG', max_length=5)),
                ('type', models.CharField(choices=[('LP', 'Normal payment'), ('DP', 'Down payment long term lease')], default='LP', max_length=5)),
                ('amount', models.PositiveIntegerField()),
                ('createdOn', models.DateTimeField(auto_now_add=True)),
                ('order', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='payment', to='core.order')),
            ],
            bases=(django_lifecycle.mixins.LifecycleModelMixin, models.Model),
        ),
        migrations.CreateModel(
            name='Pricing',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('type', models.CharField(choices=[('RT', 'Renting for a few days'), ('LE', 'Leasing for a long period')], default='RT', max_length=5)),
                ('period', models.CharField(choices=[('HR', 'Per hour pricing rate'), ('DY', 'Per day pricing rate'), ('MH', 'Per month pricing rate')], default='DY', max_length=5)),
                ('amount', models.PositiveIntegerField()),
                ('downPaymentAmount', models.PositiveIntegerField(blank=True, null=True)),
                ('item', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='prices', to='core.item')),
            ],
        ),
        migrations.CreateModel(
            name='Rating',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('item', models.PositiveIntegerField(default=0, validators=[django.core.validators.MaxLengthValidator(5)])),
                ('lender', models.PositiveIntegerField(default=0, validators=[django.core.validators.MaxLengthValidator(5)])),
                ('borrower', models.PositiveIntegerField(default=0, validators=[django.core.validators.MaxLengthValidator(5)])),
                ('order', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='rating', to='core.order')),
            ],
        ),
        migrations.CreateModel(
            name='Refund',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('amount', models.PositiveIntegerField()),
                ('payment', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='refund', to='core.payment')),
            ],
        ),
        migrations.CreateModel(
            name='ShopMembershipToken',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('token', models.CharField(max_length=8, unique=True)),
                ('createdOn', models.DateTimeField(auto_now_add=True)),
                ('validFrom', models.DateTimeField(default=django.utils.timezone.now)),
                ('validTill', models.DateTimeField(default=django.utils.timezone.now)),
                ('valid', models.BooleanField(default=True)),
                ('role', models.CharField(choices=[('OR', 'Owner'), ('AN', 'Admin')], default='AN', max_length=5)),
                ('createdBy', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='created_tokens', to=settings.AUTH_USER_MODEL)),
                ('shop', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tokens', to='core.shop')),
                ('user', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='tokens', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'abstract': False,
            },
            bases=(django_lifecycle.mixins.LifecycleModelMixin, models.Model),
        ),
        migrations.CreateModel(
            name='Transaction',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('type', models.CharField(choices=[('PT', 'Borrower paid the lender'), ('RD', 'Lender refunded borrower their money'), ('WL', 'Shop or user withdrew their money')], default='PT', max_length=5)),
                ('sentFromObjectId', models.CharField(null=True)),
                ('sentToObjectId', models.CharField(null=True)),
                ('amount', models.PositiveIntegerField()),
                ('createdOn', models.DateTimeField(auto_now_add=True)),
                ('payment', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='transactions', to='core.payment')),
                ('sentFromObject', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, related_name='transactionsfrom', to='contenttypes.contenttype')),
                ('sentToObject', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, related_name='transactionsto', to='contenttypes.contenttype')),
            ],
            bases=(django_lifecycle.mixins.LifecycleModelMixin, models.Model),
        ),
        migrations.CreateModel(
            name='UserAuthToken',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('token', models.CharField(max_length=8, unique=True)),
                ('createdOn', models.DateTimeField(auto_now_add=True)),
                ('validFrom', models.DateTimeField(default=django.utils.timezone.now)),
                ('validTill', models.DateTimeField(default=django.utils.timezone.now)),
                ('valid', models.BooleanField(default=True)),
                ('type', models.CharField(choices=[('LN', 'User Login'), ('RR', 'User Registration')], default='LN', max_length=5)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='auth_tokens', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Wallet',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('balance', models.PositiveIntegerField()),
                ('shop', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='wallet', to='core.shop')),
                ('user', models.OneToOneField(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='wallet', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='ShopMembership',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('role', models.CharField(choices=[('OR', 'Owner'), ('AN', 'Admin')], default='OR', max_length=5)),
                ('joinedOn', models.DateTimeField(auto_now_add=True)),
                ('shop', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='staff', to='core.shop')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='shops', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'unique_together': {('user', 'shop')},
            },
        ),
    ]
