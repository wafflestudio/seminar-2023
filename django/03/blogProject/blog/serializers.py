from rest_framework import serializers

from blog.models import Post


class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ["pk", "title", "description", "created_at", "updated_at"]
        read_only_fields = ["pk", "created_at", "updated_at"]
