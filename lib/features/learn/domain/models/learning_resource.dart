/// Resource type categories.
enum ResourceType {
  doc('doc', 'Doc'),
  repo('repo', 'Repo'),
  guide('guide', 'Guide');

  const ResourceType(this.slug, this.label);
  final String slug;
  final String label;
}

/// Represents a curated learning resource or external documentation card.
class ResourceItem {
  const ResourceItem({
    required this.id,
    required this.title,
    required this.type,
    required this.topic,
    required this.url,
    required this.description,
    this.estimatedReadTime = '5 min read',
    this.author = 'GDGoC PSIT',
  });

  final String id;
  final String title;
  final ResourceType type;
  final String topic;
  final String url;
  final String description;
  final String estimatedReadTime;
  final String author;
}
