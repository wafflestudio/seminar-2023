from rest_framework import serializers

from blog.models import Post, Comment


class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = [
            "pk",
            "post",
            "created_by",
            "created_at",
            "updated_at",
            "description",
        ]
        read_only_fields = [
            "pk",
            "created_at",
            "updated_at",
            "created_by",
        ]


class PostSerializer(serializers.ModelSerializer):
    comment_set = CommentSerializer(many=True)

    class Meta:
        model = Post
        fields = [
            "pk",
            "title",
            "description",
            "created_at",
            "updated_at",
            "created_by",
            "comment_set",
        ]
        read_only_fields = [
            "pk",
            "created_at",
            "updated_at",
            "created_by",
            "comment_set",
        ]
