from django.contrib import admin
from core.models import LandVehicle, Pricing, User, UserSetting, Vehicle, VehicleImage

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['fullName', 'email', 'phone', 'verifiedEmail']

@admin.register(UserSetting)
class UserSettingAdmin(admin.ModelAdmin):
    list_display = ['user']


@admin.register(Vehicle)
class VehicleAdmin(admin.ModelAdmin):
    list_display = ['brand', 'model', 'yom', 'category']

@admin.register(VehicleImage)
class VehicleImageAdmin(admin.ModelAdmin):
    list_display = ['vehicle']


@admin.register(LandVehicle)
class LandVehicleAdmin(admin.ModelAdmin):
    pass


@admin.register(Pricing)
class PricingAdmin(admin.ModelAdmin):
    pass