from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse_lazy
from django.views import generic

from blog.forms import PostForm
from blog.models import Post


class PostListView(generic.ListView):
    model = Post
    template_name = "post_list.html"


class PostDetailView(generic.DetailView):
    model = Post
    template_name = "post_detail.html"


class PostCreateView(LoginRequiredMixin, generic.CreateView):
    model = Post
    template_name = "post_create.html"
    success_url = reverse_lazy("post_list")
    form_class = PostForm

    def get_form_kwargs(self):
        return {**super().get_form_kwargs(), "user": self.request.user}
