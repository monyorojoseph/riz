import json
from typing import Any
from django.core.management.base import BaseCommand, CommandError
from core.models import VehicleModel, VehicleBrand


class Command(BaseCommand):
    help = "Create vehicle brand and models"

    def handle(self, *args: Any, **options: Any) -> str | None:
        with open("cars.json") as f:
            cars = json.load(f)
            for brand, models in cars.items():
                b = VehicleBrand.objects.create(name=brand)
                mdls = [VehicleModel(name=md, brand=b) for md in models ]
                VehicleModel.objects.bulk_create(mdls)
            self.stdout.write(
                self.style.SUCCESS('Successfully DONE ! ): ')
            )
