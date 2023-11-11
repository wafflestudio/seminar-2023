from django.contrib import admin
from django.urls import path, include

from blog.views import (
    PostCreateView,
    PostListView,
    PostDetailView,
    PostListCreateAPI,
    PostUpdateRetrieveDeleteAPI,
    CommentCreateAPI,
    CommentRetrieveUpdateDestroyAPI,
)

urlpatterns = [
    path("posts/create/", PostCreateView.as_view(), name="post_create"),
    path("posts/detail/<int:pk>/", PostDetailView.as_view(), name="post_detail"),
    path("posts/", PostListView.as_view(), name="post_list"),
    path(
        "api/",
        include(
            [
                path("posts/", PostListCreateAPI.as_view()),
                path("posts/<int:pk>/", PostUpdateRetrieveDeleteAPI.as_view()),
                path("comments/", CommentCreateAPI.as_view()),
                path("comments/<int:pk>/", CommentRetrieveUpdateDestroyAPI.as_view()),
            ]
        ),
    ),
]
