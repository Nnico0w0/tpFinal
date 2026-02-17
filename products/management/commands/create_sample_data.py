from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from products.models import Category, Product
from users.models import Person, UserProfile


class Command(BaseCommand):
    help = 'Create sample data for testing the hosting services store'

    def handle(self, *args, **kwargs):
        self.stdout.write('Creating sample data...')

        # Create categories
        categories_data = [
            {'name': 'Shared Hosting', 'slug': 'shared-hosting'},
            {'name': 'VPS Hosting', 'slug': 'vps-hosting'},
            {'name': 'Dedicated Servers', 'slug': 'dedicated-servers'},
            {'name': 'Cloud Hosting', 'slug': 'cloud-hosting'},
        ]

        categories = {}
        for cat_data in categories_data:
            cat, created = Category.objects.get_or_create(
                slug=cat_data['slug'],
                defaults={'name': cat_data['name']}
            )
            categories[cat_data['slug']] = cat
            if created:
                self.stdout.write(f'✓ Created category: {cat.name}')

        # Create products
        products_data = [
            # Shared Hosting
            {
                'name': 'Basic Shared',
                'slug': 'basic-shared',
                'category': 'shared-hosting',
                'description': 'Perfect for small websites and blogs. Includes free SSL and daily backups.',
                'price': 4.99,
                'storage_gb': 10,
                'ram_gb': 1,
                'cpu_cores': '1 Core',
            },
            {
                'name': 'Professional Shared',
                'slug': 'professional-shared',
                'category': 'shared-hosting',
                'description': 'Great for growing websites. More resources and unlimited databases.',
                'price': 9.99,
                'storage_gb': 50,
                'ram_gb': 2,
                'cpu_cores': '2 Cores',
            },
            # VPS Hosting
            {
                'name': 'VPS Starter',
                'slug': 'vps-starter',
                'category': 'vps-hosting',
                'description': 'Entry-level VPS with full root access and dedicated resources.',
                'price': 19.99,
                'storage_gb': 50,
                'ram_gb': 4,
                'cpu_cores': '2 Cores',
            },
            {
                'name': 'VPS Business',
                'slug': 'vps-business',
                'category': 'vps-hosting',
                'description': 'Perfect for medium-sized applications with high traffic.',
                'price': 39.99,
                'storage_gb': 100,
                'ram_gb': 8,
                'cpu_cores': '4 Cores',
            },
            {
                'name': 'VPS Enterprise',
                'slug': 'vps-enterprise',
                'category': 'vps-hosting',
                'description': 'Maximum performance for demanding applications.',
                'price': 79.99,
                'storage_gb': 200,
                'ram_gb': 16,
                'cpu_cores': '8 Cores',
            },
            # Dedicated Servers
            {
                'name': 'Dedicated Basic',
                'slug': 'dedicated-basic',
                'category': 'dedicated-servers',
                'description': 'Entry-level dedicated server with full control.',
                'price': 99.99,
                'storage_gb': 500,
                'ram_gb': 16,
                'cpu_cores': '8 Cores',
            },
            {
                'name': 'Dedicated Pro',
                'slug': 'dedicated-pro',
                'category': 'dedicated-servers',
                'description': 'High-performance dedicated server for enterprise applications.',
                'price': 199.99,
                'storage_gb': 1000,
                'ram_gb': 32,
                'cpu_cores': '16 Cores',
            },
            # Cloud Hosting
            {
                'name': 'Cloud Starter',
                'slug': 'cloud-starter',
                'category': 'cloud-hosting',
                'description': 'Scalable cloud hosting with auto-scaling capabilities.',
                'price': 29.99,
                'storage_gb': 100,
                'ram_gb': 4,
                'cpu_cores': '4 Cores',
            },
            {
                'name': 'Cloud Business',
                'slug': 'cloud-business',
                'category': 'cloud-hosting',
                'description': 'Advanced cloud solution with load balancing.',
                'price': 59.99,
                'storage_gb': 250,
                'ram_gb': 8,
                'cpu_cores': '8 Cores',
            },
        ]

        for prod_data in products_data:
            category_slug = prod_data.pop('category')
            category = categories[category_slug]
            
            prod, created = Product.objects.get_or_create(
                slug=prod_data['slug'],
                defaults={**prod_data, 'category': category}
            )
            if created:
                self.stdout.write(f'✓ Created product: {prod.name}')

        # Create admin user
        admin_user, created = User.objects.get_or_create(
            username='admin',
            defaults={
                'email': 'admin@hostingstore.com',
                'is_staff': True,
                'is_superuser': True,
            }
        )
        if created:
            admin_user.set_password('admin123')
            admin_user.save()
            
            # Create Person for admin
            admin_person = Person.objects.create(
                first_name='Admin',
                last_name='User',
                email='admin@hostingstore.com',
                phone='+1234567890'
            )
            
            # Create UserProfile for admin
            UserProfile.objects.create(
                user=admin_user,
                person=admin_person,
                role='ADMIN',
                is_active=True
            )
            self.stdout.write(f'✓ Created admin user (username: admin, password: admin123)')

        # Create test customer
        customer_user, created = User.objects.get_or_create(
            username='customer',
            defaults={'email': 'customer@test.com'}
        )
        if created:
            customer_user.set_password('customer123')
            customer_user.save()
            
            # Create Person for customer
            customer_person = Person.objects.create(
                first_name='John',
                last_name='Doe',
                email='customer@test.com',
                phone='+0987654321'
            )
            
            # Create UserProfile for customer
            UserProfile.objects.create(
                user=customer_user,
                person=customer_person,
                role='CUSTOMER',
                is_active=True
            )
            self.stdout.write(f'✓ Created test customer (username: customer, password: customer123)')

        self.stdout.write(self.style.SUCCESS('\n✅ Sample data created successfully!'))
        self.stdout.write('\nYou can now login with:')
        self.stdout.write('  Admin: username=admin, password=admin123')
        self.stdout.write('  Customer: username=customer, password=customer123')
