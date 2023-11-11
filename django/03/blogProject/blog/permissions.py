import typing

from rest_framework import permissions

from blog.models import Post, Comment


class IsOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj: typing.Union[Post, Comment]):
        # Read permissions are allowed to any request,
        # so we'll always allow GET, HEAD or OPTIONS requests.
        if request.method in permissions.SAFE_METHODS:
            return True

        # Instance must have an attribute named `owner`.
        return obj.created_by == request.user
