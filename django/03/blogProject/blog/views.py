from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse_lazy
from django.views import generic
from .pagination import CursorPagination
from rest_framework.permissions import IsAuthenticatedOrReadOnly

from blog.forms import PostForm, CommentForm
from blog.models import Post
from rest_framework import generics

from blog.permissions import IsOwnerOrReadOnly
from blog.serializers import PostSerializer


class PostListView(generic.ListView):
    model = Post
    template_name = "post_list.html"


class PostDetailView(generic.DetailView):
    model = Post
    template_name = "post_detail.html"

    def get_comment_form(self):
        return CommentForm(self.request.POST or None)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["form"] = (
            kwargs.get("form") if kwargs.get("form") else self.get_comment_form()
        )
        return context

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        form = self.get_comment_form()
        if form.is_valid():
            comment = form.save(commit=False)
            comment.post = self.object
            comment.created_by = request.user
            comment.save()
        return self.render_to_response(self.get_context_data(form=form))


class PostCreateView(LoginRequiredMixin, generic.CreateView):
    model = Post
    template_name = "post_create.html"
    success_url = reverse_lazy("post_list")
    form_class = PostForm

    def form_valid(self, form):
        """If the form is valid, save the associated model."""
        self.object = form.save(commit=False)
        self.object.created_by = self.request.user
        self.object.save()
        return super().form_valid(form)


class PostListCreateAPI(generics.ListCreateAPIView):
    serializer_class = PostSerializer
    queryset = Post.objects.all()
    permission_classes = (IsAuthenticatedOrReadOnly,)
    pagination_class = CursorPagination

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class PostUpdateRetrieveDeleteAPI(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = PostSerializer
    queryset = Post.objects.all()
    permission_classes = (IsOwnerOrReadOnly,)
