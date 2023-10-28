from django.views import generic

from blog.models import Post


class PostListView(generic.ListView):
    model = Post
    template_name = 'post_list.html'


class PostCreateView(generic.CreateView):
    model = Post
    template_name = 'post_create.html'
    fields = ['title', 'description']
