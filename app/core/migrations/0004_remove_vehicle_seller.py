# Generated by Django 5.0.1 on 2024-06-22 10:18

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0003_landvehicle_alter_user_sex_vehicle_vehicleimage'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='vehicle',
            name='seller',
        ),
    ]