from django.contrib import admin
from django.urls import path, include

from blog.views import PostCreateView

urlpatterns = [
    path('posts/create/', PostCreateView.as_view(), name='post_create'),
]
