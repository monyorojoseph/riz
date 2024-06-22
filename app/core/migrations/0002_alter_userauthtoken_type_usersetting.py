# Generated by Django 5.0.1 on 2024-06-21 19:11

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userauthtoken',
            name='type',
            field=models.CharField(choices=[('LN', 'User Login'), ('RR', 'User Registration'), ('FY', 'User Email Verification')], default='LN', max_length=5),
        ),
        migrations.CreateModel(
            name='UserSetting',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('appPurpose', models.CharField(choices=[('CLT', 'User as Client'), ('SLR', 'User as normal seller')], default='CLT')),
                ('currentScreen', models.CharField(choices=[('CSCRN', 'Client Screen'), ('SSCRN', 'Seller Screen')], default='CSCRN')),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='usersetting', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
