import 'package:latlong2/latlong.dart';
import '../models/destination.dart';
import '../utils/app_constants.dart';

// DESTINATION DATA

const List<Destination> destinations = [
  Destination(
    name: 'Nasugbu Beach',
    location: 'Nasugbu, Batangas',
    category: 'Beach',
    description:
    'Relax by the sea, enjoy the coastal scenery, and experience the beauty of Nasugbu.',
    image:
    'https://twomonkeystravelgroup.com/wp-content/uploads/2020/05/Travel-Guide-to-Nasugbu-Batangas-Philippines-DIY-03.jpg',
    coordinates: LatLng(14.0667, 120.6333),
    rating: '4.8',
  ),
  Destination(
    name: 'Fortune Island',
    location: 'Nasugbu, Batangas',
    category: 'Island',
    description:
    'Discover a beautiful island known for its clear waters, rocky coastline, and Greek-inspired ruins.',
    image:
    'https://www.e-philippines.com.ph/wp-content/uploads/2024/07/Fortune-Island-Day-Tour-Package-with-Land-Transfer.jpg',
    coordinates: LatLng(14.055, 120.492),
    rating: '4.9',
  ),
  Destination(
    name: 'Mount Batulao',
    location: 'Nasugbu, Batangas',
    category: 'Mountain',
    description:
    'Enjoy scenic mountain views and an outdoor adventure surrounded by rolling hills.',
    image:
    'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj3qM3BlyW05fn_RdYQkVz3ri371h-Hd4ZFgpzRVQKtRILSi_j73fsSnyun2UguoJZ3ZC0BjBeaBNMQL9l5HCTJViwW6gKsdzIojoHTm3hC2O9Eszdtc2gny3q7WTesM2akuuNP9x4iHGY/s1600/2+-+The+Magnificent+View+Along+The+Trail.jpg',
    coordinates: LatLng(14.0475, 120.8053),
    rating: '4.8',
  ),
  Destination(
    name: 'Caleruega',
    location: 'Nasugbu area, Batangas',
    category: 'Nature',
    description:
    'Visit a peaceful destination known for its gardens, architecture, and relaxing surroundings.',
    image:
    'https://shoestringdiary.wordpress.com/wp-content/uploads/2023/12/caleruega07-ssdiaries.jpg',
    coordinates: LatLng(14.095, 120.864),
    rating: '4.7',
  ),
  Destination(
    name: 'Kaybiang Tunnel',
    location: 'Nasugbu, Batangas',
    category: 'Scenic Spot',
    description:
    'Famously known as the longest subterranean road tunnel in the Philippines. Boring right through Mt. Palay-Palay, emerging from the tunnel awards motorists with an expansive, breathtaking view of the Batangas coast.',
    image:
    'https://d1tjylbhswro2u.cloudfront.net/images/posts/post19748.jpg',
    coordinates: LatLng(14.234037, 120.632812),
    rating: '4.7',
  ),
];

// FOOD DATA

const List<Map<String, String>> foodPlaces = [
  {
    'name': 'Kainan sa Dalampasigan',
    'detail': 'Filipino comfort food, grilled dishes, and seafood.',
    'category': 'Filipino & Seafood',
    'image':
    'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0b/58/69/88/20160129-140154-largejpg.jpg?w=1200&h=1200&s=1',
  },
  {
    'name': 'El Cocinero',
    'detail': 'Spanish-inspired dishes, paella, seafood, pizza, and pasta.',
    'category': 'Spanish & Mediterranean',
    'image':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQErT65syNtlO3fKP8dOiq4c5unr085nXJyN8TimZMuTGEr437GdbiSNC6&s=10',
  },
  {
    'name': 'La Locanda Ristorante Pizzeria',
    'detail': 'Italian-style pizza, pasta, and other Italian favorites.',
    'category': 'Italian & Pizza',
    'image':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4d5BBKkzw4v3dvhAZ8e1QqRDTQwWahXNZnkww6nYW4a8vSQkMlPLQscnm&s=10',
  },
  {
    'name': 'L’Bulalo Restaurant Nasugbu',
    'detail': 'Filipino home-style meals, bulalo, and seafood dishes.',
    'category': 'Filipino Favorites',
    'image':
    'https://d3fphkxyf5o5bm.cloudfront.net/image-resize/format=webp,w=720/Q524tReNnAnmuqp47gXRbBVUT2eTLe2VP0o2GScyPa',
  },
  {
    'name': 'Bayani’s Lomi House & Restaurant',
    'detail': 'Batangas-style lomi, Filipino comfort food, and merienda.',
    'category': 'Lomi & Filipino',
    'image':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaerDCNujYLZdpLKb5Kb6NCtCK7ATtQfNnfkYnSmOc9uYxr6gJg1T4ePws&s=10',
  },
];

// ACTIVITIES DATA

const List<Map<String, String>> activities = [
  {
    'name': 'Island Hopping',
    'detail': 'Explore nearby island scenery and coastal views.',
    'image':
    'https://www.sidive.com/wp-content/uploads/2020/03/Island-hopping-in-Cebu-768x510.jpg',
    'category': 'Water Adventure',
    'icon': 'boat',
  },
  {
    'name': 'Snorkeling',
    'detail': 'Discover marine life and enjoy the underwater world.',
    'image':
    'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1000&q=85',
    'category': 'Water Activity',
    'icon': 'water',
  },
  {
    'name': 'Hiking',
    'detail': 'Explore mountain trails and enjoy scenic viewpoints.',
    'image':
    'https://images.unsplash.com/photo-1551632811-561732d1e306?auto=format&fit=crop&w=1000&q=85',
    'category': 'Outdoor Adventure',
    'icon': 'hiking',
  },
  {
    'name': 'Beach Relaxation',
    'detail': 'Enjoy the sea, sunshine, and peaceful coastal scenery.',
    'image': beachImage,
    'category': 'Relaxation',
    'icon': 'beach',
  },
  {
    'name': 'Local Food Trip',
    'detail': 'Taste Batangas favorites and Filipino comfort food.',
    'image':
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1000&q=85',
    'category': 'Food Experience',
    'icon': 'food',
  },
];