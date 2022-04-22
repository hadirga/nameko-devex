from pydantic import BaseModel
from typing import List

class Product(BaseModel):
    id: str
    title: str
    passenger_capacity: int
    maximum_speed: int
    in_stock: int


class CreateOrderDetail(BaseModel):
    product_id: str
    price: float
    quantity: int

class CreateOrder(BaseModel):
    order_details: List[CreateOrderDetail]

class CreateOrderSuccess(BaseModel):
    id: int

class CreateProductSuccess(BaseModel):
    id: str

class DeleteProductSuccess(BaseModel):
    message: str