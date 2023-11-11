from rest_framework.pagination import CursorPagination as BaseCursorPagination


class CursorPagination(BaseCursorPagination):
    page_size = 20
    ordering = "-created_at"
