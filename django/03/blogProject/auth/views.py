from django.contrib.auth import views as auth_views


class LoginView(auth_views.LoginView):
    template_name = "login.html"


class LogoutView(auth_views.LogoutView):
    template_name = "logout.html"
