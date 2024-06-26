# Generated by Django 5.0.1 on 2024-06-22 10:07

import django.db.models.deletion
import uuid
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
        ('core', '0002_alter_userauthtoken_type_usersetting'),
    ]

    operations = [
        migrations.CreateModel(
            name='LandVehicle',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('engineType', models.CharField(blank=True, choices=[('CN', 'Combustion engine'), ('HD', 'Hybrid engine'), ('EC', 'Electric engine')], max_length=5, null=True)),
                ('engineSize', models.CharField(blank=True, null=True)),
                ('doors', models.PositiveIntegerField(blank=True, null=True)),
                ('passengers', models.PositiveIntegerField(default=1)),
                ('load', models.PositiveIntegerField()),
                ('fuelType', models.CharField(blank=True, choices=[('DSL', 'Diesel'), ('PTL', 'Petrol'), ('ELC', 'Electric'), ('HBD', 'Hybrid')], max_length=5, null=True)),
                ('transmission', models.CharField(blank=True, choices=[('AT', 'Automatic'), ('ML', 'Manual'), ('CVT', 'CVT')], max_length=5, null=True)),
                ('drivetrain', models.CharField(blank=True, choices=[('4WD', 'Four Wheel'), ('2WD', 'Two Wheel'), ('AWD', 'All Wheel')], max_length=5, null=True)),
                ('type', models.CharField(choices=[('LND', 'Land vehicles'), ('WTR', 'Watercraft'), ('AIR', 'Aircraft')], default='SC', max_length=5)),
            ],
        ),
        migrations.AlterField(
            model_name='user',
            name='sex',
            field=models.CharField(choices=[('ML', 'Male'), ('FML', 'Female'), ('NN', "Don't want to identify")], default='NN'),
        ),
        migrations.CreateModel(
            name='Vehicle',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('modelName', models.CharField(max_length=200)),
                ('brandName', models.CharField(max_length=200)),
                ('yom', models.CharField(max_length=6, null=True)),
                ('category', models.CharField(choices=[('LND', 'Land vehicles'), ('WTR', 'Watercraft'), ('AIR', 'Aircraft')], default='LND', max_length=3)),
                ('vehicleObjectId', models.PositiveIntegerField(null=True)),
                ('display', models.BooleanField(default=False)),
                ('createdOn', models.DateTimeField(auto_now_add=True)),
                ('updatedOn', models.DateTimeField(auto_now=True)),
                ('seller', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='vehicles', to=settings.AUTH_USER_MODEL)),
                ('vehicleObject', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='contenttypes.contenttype')),
            ],
        ),
        migrations.CreateModel(
            name='VehicleImage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.ImageField(upload_to='vehicles')),
                ('coverImage', models.BooleanField(default=False)),
                ('vehicle', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='images', to='core.vehicle')),
            ],
        ),
    ]
