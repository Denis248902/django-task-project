from django.test import TestCase
from django.core.files.uploadedfile import SimpleUploadedFile
from io import BytesIO
from PIL import Image
from emp_app.models import EmployeeProfile, EmployeeImage

def get_test_image():
    byte_io = BytesIO()
    img = Image.new('RGB', (100, 100), color='red')
    img.save(byte_io, format='JPEG')
    byte_io.seek(0)
    return byte_io

class EmployeeViewsTest(TestCase):
    def setUp(self):
        self.employee = EmployeeProfile.objects.create(
            full_name='Test Employee',
            gender='M',
            position='Tester'
        )

    def test_upload_valid_image(self):
        img_file = SimpleUploadedFile(
            'test.jpg',
            get_test_image().read(),
            content_type='image/jpeg'
        )
        response = self.client.post(
            f'/employees/{self.employee.pk}/upload-photo/',
            {
                'image': img_file,
                'order_index': 1,
            },
            follow=True
        )
        self.assertEqual(response.status_code, 200)
        self.assertTrue(EmployeeImage.objects.filter(employee=self.employee).exists())

    def test_export_csv(self):
        response = self.client.get('/employees/export-csv/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response['Content-Type'], 'text/csv')
        content = response.content.decode('utf-8')
        self.assertIn('ID,Full Name,Gender,Position,Photo URLs (comma-separated)', content)
