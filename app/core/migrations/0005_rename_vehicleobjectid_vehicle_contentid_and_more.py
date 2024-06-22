# Generated by Django 5.0.1 on 2024-06-22 10:21

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0004_remove_vehicle_seller'),
    ]

    operations = [
        migrations.RenameField(
            model_name='vehicle',
            old_name='vehicleObjectId',
            new_name='contentId',
        ),
        migrations.RenameField(
            model_name='vehicle',
            old_name='vehicleObject',
            new_name='contentType',
        ),
        migrations.AddField(
            model_name='vehicle',
            name='seller',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='vehicles', to=settings.AUTH_USER_MODEL),
        ),
    ]
