import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_constants.dart';
import '../models/destination.dart';
import '../data/tourism_data.dart';
import '../services/firestore_service.dart';
import 'welcome_screen.dart';

// HOME DASHBOARD

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int _tab = 0;
String _query = '';
String _foodQuery = '';

final Set<String> _favorites = {};
final List<String> _itinerary = [];

// Added for View on Map.
Destination? _selectedMapDestination;
final MapController _mapController = MapController();

@override
void initState() {
super.initState();
_loadUserData();
}


Future<void> _loadUserData() async {
try {
final data = await FirestoreService.loadUserData();

if (data == null) return;

final savedFavorites = List<String>.from(
data['favorites'] ?? const <String>[],
);

final savedItinerary = List<String>.from(
data['itinerary'] ?? const <String>[],
);

if (!mounted) return;

setState(() {
_favorites
..clear()
..addAll(savedFavorites);

_itinerary
..clear()
..addAll(savedItinerary);
});
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Unable to load your saved data: $e'),
),
);
}
}



Future<void> _saveUserData(Map<String, dynamic> changes) async {
try {
await FirestoreService.saveUserData(changes);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Unable to save your changes: $e'),
),
);
}
}



Future<void> _toggleFavorite(String name) async {
final wasFavorite = _favorites.contains(name);

setState(() {
if (wasFavorite) {
_favorites.remove(name);
} else {
_favorites.add(name);
}
});

await _saveUserData({
'favorites': _favorites.toList(),
});
}



Future<void> _addToTrip(String name) async {
if (_itinerary.contains(name)) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('$name is already in My Trip'),
behavior: SnackBarBehavior.floating,
),
);
return;
}

setState(() => _itinerary.add(name));

await _saveUserData({
'itinerary': _itinerary.toList(),
});

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('$name added to My Trip'),
behavior: SnackBarBehavior.floating,
),
);
}



Future<void> _removeFromTrip(String name) async {
setState(() => _itinerary.remove(name));

await _saveUserData({
'itinerary': _itinerary.toList(),
});
}


// Added for View on Map.
void _viewDestinationOnMap(Destination place) {
setState(() {
_selectedMapDestination = place;
_tab = 3;
});

WidgetsBinding.instance.addPostFrameCallback((_) {
if (!mounted) return;

try {
_mapController.move(place.coordinates, 14);
} catch (_) {
// The map will also start at the selected destination.
}
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
automaticallyImplyLeading: false,
title: const Text(
'LakbayNasugbu',
style: TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
actions: [
IconButton(
tooltip: 'Log out',
icon: const Icon(Icons.logout_rounded),
onPressed: () async {
final shouldLogout = await showDialog<bool>(
context: context,
builder: (dialogContext) {
return AlertDialog(
title: const Text('Log Out'),
content: const Text(
'Are you sure you want to log out?',
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(dialogContext, false);
},
child: const Text('Cancel'),
),
FilledButton(
onPressed: () {
Navigator.pop(dialogContext, true);
},
child: const Text('Log Out'),
),
],
);
},
);

if (shouldLogout == true && context.mounted) {
await FirebaseAuth.instance.signOut();

if (!context.mounted) return;

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (_) => const WelcomeScreen(),
),
(route) => false,
);
}
},
),
const SizedBox(width: 8),
],
),
body: IndexedStack(
index: _tab,
children: [
_buildExplore(),
_buildActivities(),
_buildFood(),
_buildMap(),
_buildFavorites(),
_buildPlanner(),
],
),
bottomNavigationBar: NavigationBar(
selectedIndex: _tab,
onDestinationSelected: (value) {
setState(() => _tab = value);
},
backgroundColor: Colors.white,
indicatorColor: softMint,
destinations: const [
NavigationDestination(
icon: Icon(Icons.explore_outlined),
selectedIcon: Icon(Icons.explore),
label: 'Explore',
),
NavigationDestination(
icon: Icon(Icons.directions_walk_outlined),
selectedIcon: Icon(Icons.directions_walk),
label: 'Activities',
),
NavigationDestination(
icon: Icon(Icons.restaurant_outlined),
selectedIcon: Icon(Icons.restaurant),
label: 'Food',
),
NavigationDestination(
icon: Icon(Icons.map_outlined),
selectedIcon: Icon(Icons.map),
label: 'Map',
),
NavigationDestination(
icon: Icon(Icons.favorite_border),
selectedIcon: Icon(Icons.favorite),
label: 'Saved',
),
NavigationDestination(
icon: Icon(Icons.calendar_month_outlined),
selectedIcon: Icon(Icons.calendar_month),
label: 'My Trip',
),
],
),
);
}

// EXPLORE TAB

Widget _buildExplore() {
final filteredDestinations = destinations.where((place) {
final search = _query.toLowerCase();
return place.name.toLowerCase().contains(search) ||
place.category.toLowerCase().contains(search) ||
place.location.toLowerCase().contains(search);
}).toList();

return ListView(
padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
children: [
const Text(
'Your next adventure',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
const SizedBox(height: 6),
const Text(
'Discover the hidden gems of Nasugbu.',
style: TextStyle(
fontSize: 15,
color: Colors.black54,
),
),
const SizedBox(height: 20),
TextField(
onChanged: (value) {
setState(() => _query = value);
},
decoration: const InputDecoration(
hintText: 'Search destinations...',
prefixIcon: Icon(Icons.search_rounded),
suffixIcon: Icon(Icons.tune_rounded),
),
),
const SizedBox(height: 20),
_buildExploreHero(),
const SizedBox(height: 26),
Row(
children: [
const Expanded(
child: Text(
'Popular destinations',
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
),
Text(
'${filteredDestinations.length} places',
style: const TextStyle(
color: oceanTeal,
fontWeight: FontWeight.w600,
),
),
],
),
const SizedBox(height: 14),
if (filteredDestinations.isEmpty)
const Padding(
padding: EdgeInsets.symmetric(vertical: 30),
child: Center(
child: Text('No destinations found. Try another search.'),
),
)
else
...filteredDestinations.map(_destinationCard),
],
);
}

Widget _buildExploreHero() {
return ClipRRect(
borderRadius: BorderRadius.circular(24),
child: SizedBox(
height: 190,
child: Stack(
fit: StackFit.expand,
children: [
Image.network(
beachImage,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(color: oceanTeal);
},
),
Container(
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.centerLeft,
end: Alignment.centerRight,
colors: [
deepTeal.withValues(alpha: 0.88),
deepTeal.withValues(alpha: 0.08),
],
),
),
),
const Padding(
padding: EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'EXPLORE NASUGBU',
style: TextStyle(
color: Colors.white70,
fontSize: 11,
letterSpacing: 2,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 8),
Text(
'Find your happy place.',
style: TextStyle(
color: Colors.white,
fontSize: 23,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 6),
Text(
'Sea, mountains, and local flavor.',
style: TextStyle(
color: Colors.white,
fontSize: 13,
),
),
],
),
),
],
),
),
);
}

Widget _destinationCard(Destination place) {
final isFavorite = _favorites.contains(place.name);

return Container(
margin: const EdgeInsets.only(bottom: 18),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(22),
boxShadow: [
BoxShadow(
color: deepTeal.withValues(alpha: 0.06),
blurRadius: 15,
offset: const Offset(0, 5),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
ClipRRect(
borderRadius: const BorderRadius.vertical(
top: Radius.circular(22),
),
child: SizedBox(
height: 180,
width: double.infinity,
child: Stack(
fit: StackFit.expand,
children: [
Image.network(
place.image,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
color: softMint,
child: const Icon(
Icons.landscape_rounded,
size: 55,
color: oceanTeal,
),
);
},
),
Positioned(
top: 12,
left: 12,
child: Container(
padding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 7,
),
decoration: BoxDecoration(
color: Colors.white.withValues(alpha: 0.95),
borderRadius: BorderRadius.circular(30),
),
child: Text(
place.category,
style: const TextStyle(
color: deepTeal,
fontSize: 12,
fontWeight: FontWeight.bold,
),
),
),
),
Positioned(
top: 8,
right: 8,
child: CircleAvatar(
backgroundColor: Colors.white.withValues(alpha: 0.95),
child: IconButton(
tooltip: isFavorite
? 'Remove from saved'
: 'Save destination',
onPressed: () => _toggleFavorite(place.name),
icon: Icon(
isFavorite
? Icons.favorite
: Icons.favorite_border,
color: isFavorite ? Colors.red : deepTeal,
),
),
),
),
],
),
),
),
Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Expanded(
child: Text(
place.name,
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
),
const Icon(
Icons.star_rounded,
color: Colors.amber,
size: 20,
),
const SizedBox(width: 4),
Text(
place.rating,
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
],
),
const SizedBox(height: 8),
Row(
children: [
const Icon(
Icons.location_on_outlined,
size: 17,
color: oceanTeal,
),
const SizedBox(width: 4),
Expanded(
child: Text(
place.location,
style: const TextStyle(
color: Colors.black54,
fontSize: 13,
),
),
),
],
),
const SizedBox(height: 10),
Text(
place.description,
style: const TextStyle(
color: Colors.black54,
height: 1.5,
),
),
const SizedBox(height: 15),
SizedBox(
width: double.infinity,
child: FilledButton.icon(
style: FilledButton.styleFrom(
backgroundColor: oceanTeal,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(vertical: 13),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
onPressed: () => _addToTrip(place.name),
icon: const Icon(Icons.add_rounded),
label: const Text('Add to My Trip'),
),
),

// ONLY ADDITION: VIEW ON MAP BUTTON
const SizedBox(height: 8),
SizedBox(
width: double.infinity,
child: OutlinedButton.icon(
onPressed: () => _viewDestinationOnMap(place),
icon: const Icon(Icons.map_outlined),
label: const Text('View on Map'),
style: OutlinedButton.styleFrom(
foregroundColor: oceanTeal,
side: const BorderSide(color: oceanTeal),
padding: const EdgeInsets.symmetric(vertical: 13),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
],
),
),
],
),
);
}

// ACTIVITIES TAB

Widget _buildActivities() {
return ListView(
padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
children: [
const Text(
'Things to do',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
const SizedBox(height: 6),
const Text(
'Make the most of your Nasugbu adventure.',
style: TextStyle(color: Colors.black54),
),
const SizedBox(height: 20),
...activities.map((activity) {
return _imageFeatureCard(
title: activity['name']!,
subtitle: activity['detail']!,
category: activity['category']!,
image: activity['image']!,
buttonLabel: 'Add to My Trip',
onPressed: () => _addToTrip(activity['name']!),
);
}),
],
);
}

// FOOD TAB

Widget _buildFood() {
final filteredFood = foodPlaces.where((food) {
final search = _foodQuery.toLowerCase();
return food['name']!.toLowerCase().contains(search) ||
food['detail']!.toLowerCase().contains(search) ||
food['category']!.toLowerCase().contains(search);
}).toList();

return ListView(
padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
children: [
const Text(
'Restaurants in Nasugbu',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
const SizedBox(height: 6),
const Text(
'Explore restaurants and the cuisines they offer in Nasugbu, Batangas.',
style: TextStyle(color: Colors.black54),
),
const SizedBox(height: 20),
TextField(
onChanged: (value) {
setState(() => _foodQuery = value);
},
decoration: const InputDecoration(
hintText: 'Search restaurants or cuisine...',
prefixIcon: Icon(Icons.search_rounded),
),
),
const SizedBox(height: 20),
...filteredFood.map((food) {
return _imageFeatureCard(
title: food['name']!,
subtitle: food['detail']!,
category: food['category']!,
image: food['image']!,
buttonLabel: 'Add to My Trip',
onPressed: () => _addToTrip(food['name']!),
);
}),
if (filteredFood.isEmpty)
const Padding(
padding: EdgeInsets.all(24),
child: Center(child: Text('No restaurants found.')),
),
],
);
}

Widget _imageFeatureCard({
required String title,
required String subtitle,
required String category,
required String image,
required String buttonLabel,
required VoidCallback onPressed,
}) {
return Container(
margin: const EdgeInsets.only(bottom: 18),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(22),
boxShadow: [
BoxShadow(
color: deepTeal.withValues(alpha: 0.06),
blurRadius: 15,
offset: const Offset(0, 5),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
ClipRRect(
borderRadius: const BorderRadius.vertical(
top: Radius.circular(22),
),
child: SizedBox(
height: 175,
width: double.infinity,
child: Image.network(
image,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
color: softMint,
child: const Icon(
Icons.photo_outlined,
color: oceanTeal,
size: 50,
),
);
},
),
),
),
Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 6,
),
decoration: BoxDecoration(
color: softMint,
borderRadius: BorderRadius.circular(30),
),
child: Text(
category,
style: const TextStyle(
color: deepTeal,
fontSize: 11,
fontWeight: FontWeight.bold,
),
),
),
const SizedBox(height: 10),
Text(
title,
style: const TextStyle(
color: deepTeal,
fontWeight: FontWeight.bold,
fontSize: 20,
),
),
const SizedBox(height: 6),
Text(
subtitle,
style: const TextStyle(
color: Colors.black54,
height: 1.5,
),
),
const SizedBox(height: 14),
SizedBox(
width: double.infinity,
child: FilledButton.icon(
onPressed: onPressed,
icon: const Icon(Icons.add_rounded),
label: Text(buttonLabel),
style: FilledButton.styleFrom(
backgroundColor: oceanTeal,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(vertical: 12),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
],
),
),
],
),
);
}

// MAP TAB

Widget _buildMap() {
final selectedDestination = _selectedMapDestination;

return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Padding(
padding: EdgeInsets.fromLTRB(18, 8, 18, 5),
child: Text(
'Explore the Map',
style: TextStyle(
fontSize: 27,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
),
const Padding(
padding: EdgeInsets.fromLTRB(18, 0, 18, 14),
child: Text(
'Find destinations around Nasugbu, Batangas.',
style: TextStyle(color: Colors.black54),
),
),
Expanded(
child: ClipRRect(
borderRadius: const BorderRadius.vertical(
top: Radius.circular(22),
),
child: FlutterMap(
mapController: _mapController,
options: MapOptions(
initialCenter: selectedDestination?.coordinates ??
const LatLng(14.0667, 120.6333),
initialZoom: selectedDestination == null ? 10 : 14,
),
children: [
TileLayer(
urlTemplate:
'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
userAgentPackageName: 'com.example.lakbay_nasugbu',
),
MarkerLayer(
markers: destinations.map((place) {
return Marker(
point: place.coordinates,
width: 48,
height: 55,
child: GestureDetector(
onTap: () => _showDestinationOnMap(place),
child: Icon(
Icons.location_pin,
color: selectedDestination?.name == place.name
? Colors.red
: oceanTeal,
size: selectedDestination?.name == place.name
? 48
: 42,
),
),
);
}).toList(),
),
const RichAttributionWidget(
attributions: [
TextSourceAttribution('OpenStreetMap contributors'),
],
),
],
),
),
),
],
);
}

void _showDestinationOnMap(Destination place) {
showModalBottomSheet<void>(
context: context,
isScrollControlled: true,
backgroundColor: Colors.transparent,
builder: (sheetContext) {
return Container(
decoration: const BoxDecoration(
color: warmCream,
borderRadius: BorderRadius.vertical(
top: Radius.circular(24),
),
),
padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
child: SafeArea(
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
ClipRRect(
borderRadius: BorderRadius.circular(18),
child: SizedBox(
height: 160,
width: double.infinity,
child: Image.network(
place.image,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
color: softMint,
child: const Icon(
Icons.landscape_rounded,
size: 50,
color: oceanTeal,
),
);
},
),
),
),
const SizedBox(height: 14),
Text(
place.name,
style: const TextStyle(
color: deepTeal,
fontWeight: FontWeight.bold,
fontSize: 23,
),
),
const SizedBox(height: 5),
Text(
place.location,
style: const TextStyle(color: Colors.black54),
),
const SizedBox(height: 10),
Text(
place.description,
style: const TextStyle(height: 1.5),
),
const SizedBox(height: 15),
SizedBox(
width: double.infinity,
child: FilledButton.icon(
onPressed: () {
Navigator.pop(sheetContext);
_addToTrip(place.name);
},
icon: const Icon(Icons.add_rounded),
label: const Text('Add to My Trip'),
style: FilledButton.styleFrom(
backgroundColor: oceanTeal,
foregroundColor: Colors.white,
),
),
),
],
),
),
);
},
);
}

// SAVED DESTINATIONS TAB

Widget _buildFavorites() {
final savedPlaces = destinations
.where((place) => _favorites.contains(place.name))
.toList();

return ListView(
padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
children: [
const Text(
'Saved Places',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
const SizedBox(height: 6),
const Text(
'Your favorite places in one spot.',
style: TextStyle(color: Colors.black54),
),
const SizedBox(height: 20),
if (savedPlaces.isEmpty)
_buildEmptyState(
icon: Icons.favorite_border_rounded,
title: 'No saved places yet',
message:
'Tap the heart on a destination card to save a place here.',
)
else
...savedPlaces.map(_destinationCard),
],
);
}

// MY TRIP TAB

Widget _buildPlanner() {
return ListView(
padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
children: [
const Text(
'My Trip',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
const SizedBox(height: 6),
const Text(
'Build your own Nasugbu itinerary.',
style: TextStyle(color: Colors.black54),
),
const SizedBox(height: 20),
Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: deepTeal,
borderRadius: BorderRadius.circular(22),
),
child: Row(
children: [
const Icon(
Icons.luggage_rounded,
color: Colors.white,
size: 38,
),
const SizedBox(width: 15),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Your adventure plan',
style: TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 5),
Text(
'${_itinerary.length} ${_itinerary.length == 1 ? 'place' : 'places'} added to your trip',
style: const TextStyle(color: Colors.white70),
),
],
),
),
],
),
),
const SizedBox(height: 22),
if (_itinerary.isEmpty)
_buildEmptyState(
icon: Icons.calendar_month_outlined,
title: 'Your itinerary is empty',
message:
'Explore destinations, activities, or food and add them to My Trip.',
)
else
..._itinerary.asMap().entries.map((entry) {
final index = entry.key;
final name = entry.value;

final destinationMatches =
destinations.where((place) => place.name == name);
final destination = destinationMatches.isNotEmpty
? destinationMatches.first
: null;

final activityMatches =
activities.where((item) => item['name'] == name);
final activity =
activityMatches.isNotEmpty ? activityMatches.first : null;

final foodMatches =
foodPlaces.where((item) => item['name'] == name);
final food = foodMatches.isNotEmpty ? foodMatches.first : null;

final image = destination?.image ??
activity?['image'] ??
food?['image'] ??
beachImage;

final detail = destination?.location ??
activity?['detail'] ??
food?['detail'] ??
'Added to your itinerary';

return Container(
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(18),
),
child: Row(
children: [
ClipRRect(
borderRadius: BorderRadius.circular(13),
child: SizedBox(
width: 82,
height: 82,
child: Image.network(
image,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
color: softMint,
child: const Icon(
Icons.landscape_rounded,
color: oceanTeal,
),
);
},
),
),
),
const SizedBox(width: 12),
Container(
width: 30,
height: 30,
alignment: Alignment.center,
decoration: const BoxDecoration(
color: softMint,
shape: BoxShape.circle,
),
child: Text(
'${index + 1}',
style: const TextStyle(
color: deepTeal,
fontWeight: FontWeight.bold,
),
),
),
const SizedBox(width: 10),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
name,
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
const SizedBox(height: 5),
Text(
detail,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 12,
color: Colors.black54,
),
),
],
),
),
IconButton(
tooltip: 'Remove from trip',
onPressed: () => _removeFromTrip(name),
icon: const Icon(
Icons.delete_outline_rounded,
color: Colors.redAccent,
),
),
],
),
);
}),
if (_itinerary.isNotEmpty) ...[
const SizedBox(height: 8),
OutlinedButton.icon(
onPressed: () async {
setState(() => _itinerary.clear());
await _saveUserData({'itinerary': <String>[]});
},
icon: const Icon(Icons.delete_sweep_outlined),
label: const Text('Clear itinerary'),
style: OutlinedButton.styleFrom(
foregroundColor: deepTeal,
padding: const EdgeInsets.symmetric(vertical: 13),
),
),
],
],
);
}

// EMPTY STATE

Widget _buildEmptyState({
required IconData icon,
required String title,
required String message,
}) {
return Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(
horizontal: 22,
vertical: 32,
),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(22),
),
child: Column(
children: [
Container(
width: 68,
height: 68,
decoration: const BoxDecoration(
color: softMint,
shape: BoxShape.circle,
),
child: Icon(
icon,
color: oceanTeal,
size: 34,
),
),
const SizedBox(height: 16),
Text(
title,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
color: deepTeal,
),
),
const SizedBox(height: 8),
Text(
message,
textAlign: TextAlign.center,
style: const TextStyle(
color: Colors.black54,
height: 1.5,
),
),
],
),
);
}
}
