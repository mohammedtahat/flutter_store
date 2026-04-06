// lib/models/product_model.dart

class ReviewModel {
  final String userName;
  final double rating;
  final String comment;
  final String date;

  ReviewModel({required this.userName, required this.rating, required this.comment, required this.date});
}

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double oldPrice;
  final List<String> images;
  final String category;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isNew;
  final bool isBestSeller;
  final List<ReviewModel> reviews;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.images,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.stock = 10,
    this.isNew = false,
    this.isBestSeller = false,
    this.reviews = const [],
  });

  double get discountPercent => oldPrice > 0 ? ((oldPrice - price) / oldPrice * 100) : 0;
  String get mainImage => images.isNotEmpty ? images.first : '';

  static List<ProductModel> dummy = [
    ProductModel(
      id: 1, name: 'AirPods Pro (2nd Gen)',
      description: 'سماعات لاسلكية بتقنية إلغاء الضوضاء النشط المتطورة. تمنحك تجربة صوتية غامرة مع بطارية تدوم 30 ساعة مع علبة الشحن.',
      price: 249.99, oldPrice: 329.99,
      images: [
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600',
        'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=600',
        'https://images.unsplash.com/photo-1628202926206-c63a34b1b48a?w=600',
      ],
      category: 'سماعات', rating: 4.8, reviewCount: 1240, isNew: true, isBestSeller: true,
      reviews: [
        ReviewModel(userName: 'أحمد خالد', rating: 5, comment: 'منتج رائع جداً! الصوت نقي والبطارية ممتازة', date: '15 مارس 2025'),
        ReviewModel(userName: 'سارة محمد', rating: 4.5, comment: 'جودة عالية وراحة في الاستخدام', date: '10 مارس 2025'),
      ],
    ),
    ProductModel(
      id: 2, name: 'Apple Watch Ultra 2',
      description: 'الساعة الأكثر متانة من Apple مع شاشة OLED الأكبر والأسطع. مثالية للرياضيين ومحبي المغامرات.',
      price: 799.99, oldPrice: 899.99,
      images: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600',
      ],
      category: 'ساعات', rating: 4.7, reviewCount: 856, isBestSeller: true,
      reviews: [
        ReviewModel(userName: 'عمر حسن', rating: 5, comment: 'تحفة فنية! التصميم راقي والأداء ممتاز', date: '20 فبراير 2025'),
      ],
    ),
    ProductModel(
      id: 3, name: 'MacBook Pro M3 Pro',
      description: 'قوة معالج M3 Pro المذهلة مع شاشة Liquid Retina XDR بدقة 14 بوصة. للمحترفين الذين لا يقبلون بالأقل.',
      price: 1999.99, oldPrice: 2299.99,
      images: [
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600',
        'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=600',
      ],
      category: 'لابتوب', rating: 4.9, reviewCount: 2100, isNew: true,
      reviews: [
        ReviewModel(userName: 'ليلى عبدالله', rating: 5, comment: 'أسرع لابتوب استخدمته في حياتي', date: '5 مارس 2025'),
      ],
    ),
    ProductModel(
      id: 4, name: 'iPhone 15 Pro Max',
      description: 'أحدث هواتف Apple بإطار تيتانيوم فاخر وكاميرا 48MP احترافية مع تقنية ProRes للفيديو.',
      price: 1199.99, oldPrice: 1399.99,
      images: [
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600',
      ],
      category: 'هواتف', rating: 4.8, reviewCount: 3420, isBestSeller: true,
      reviews: [
        ReviewModel(userName: 'خالد ناصر', rating: 5, comment: 'الكاميرا خيالية والأداء لا يُضاهى', date: '1 مارس 2025'),
        ReviewModel(userName: 'نور حمدان', rating: 4.5, comment: 'السعر مرتفع لكن يستحق كل ريال', date: '25 فبراير 2025'),
      ],
    ),
    ProductModel(
      id: 5, name: 'Sony PlayStation 5 Pro',
      description: 'جهاز الألعاب الأقوى من سوني مع رسومات 8K وتقنية ray tracing. تجربة لا مثيل لها.',
      price: 699.99, oldPrice: 799.99,
      images: [
        'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=600',
        'https://images.unsplash.com/photo-1607853202273-232359f00d87?w=600',
      ],
      category: 'ألعاب', rating: 4.8, reviewCount: 5670, isNew: true, isBestSeller: true,
    ),
    ProductModel(
      id: 6, name: 'iPad Pro M2 12.9"',
      description: 'تابلت احترافي بشاشة mini-LED مذهلة ومعالج M2 الفائق. مدعوم بـ Apple Pencil 2 وـ Magic Keyboard.',
      price: 1099.99, oldPrice: 1299.99,
      images: [
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=600',
        'https://images.unsplash.com/photo-1589739900243-4b52cd9b104e?w=600',
      ],
      category: 'تابلت', rating: 4.6, reviewCount: 1890, isNew: true,
    ),
    ProductModel(
      id: 7, name: 'Samsung OLED 65" 4K',
      description: 'تلفزيون OLED بدقة 4K مع تقنية HDR10+ ومعالج Neural Quantum للصورة الأكثر حيوية.',
      price: 1799.99, oldPrice: 2199.99,
      images: [
        'https://images.unsplash.com/photo-1593359677879-a4bb92f829e1?w=600',
      ],
      category: 'تلفزيونات', rating: 4.6, reviewCount: 743, isBestSeller: true,
    ),
    ProductModel(
      id: 8, name: 'Sony Alpha ZV-E1',
      description: 'كاميرا فيديو احترافية بمستشعر Full-Frame ومعالج BIONZ XR. الأمثل لصانعي المحتوى.',
      price: 2199.99, oldPrice: 2599.99,
      images: [
        'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=600',
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600',
      ],
      category: 'كاميرات', rating: 4.9, reviewCount: 432,
    ),
    ProductModel(
      id: 9, name: 'DJI Mini 4 Pro',
      description: 'أصغر طائرة بدون طيار احترافية بكاميرا 4K/60fps وخاصية تتبع الموضوع الذكي.',
      price: 759.99, oldPrice: 899.99,
      images: [
        'https://images.unsplash.com/photo-1507582020474-9a35b7d455d9?w=600',
      ],
      category: 'درونز', rating: 4.7, reviewCount: 328, isNew: true,
    ),
    ProductModel(
      id: 10, name: 'Samsung Galaxy S24 Ultra',
      description: 'هاتف Android الأقوى بقلم S Pen مدمج وكاميرا 200MP ومعالج Snapdragon 8 Gen 3.',
      price: 1299.99, oldPrice: 1499.99,
      images: [
        'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=600',
      ],
      category: 'هواتف', rating: 4.6, reviewCount: 2850, isBestSeller: true,
    ),
  ];
}