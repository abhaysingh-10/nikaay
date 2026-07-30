import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Elegant Header with stretched banner image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primaryGreen,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    article.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  // Dark bottom gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Article Body Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: const BoxDecoration(
                color: AppColors.mainBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Tag and Read Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: AppColors.secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            article.readTime,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main Article Title
                  Text(
                    article.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Author & Date Information
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.warmBeige,
                        radius: 20,
                        child: Text(
                          article.author.substring(0, 1),
                          style: GoogleFonts.playfairDisplay(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              article.publishDate,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 36, thickness: 1, color: AppColors.warmBeige),

                  // Main Parsed Content
                  _buildContentPart(article.content, context),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Parses markdown lines into rich Flutter widgets
  Widget _buildContentPart(String text, BuildContext context) {
    final lines = text.split('\n');
    final children = <Widget>[];

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        children.add(const SizedBox(height: 12));
        continue;
      }

      if (trimmed.startsWith('### ')) {
        // Strip the heading tag and style as sub-heading
        final headingText = trimmed.substring(4);
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
            child: Text(
              headingText,
              style: GoogleFonts.playfairDisplay(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
          ),
        );
      } else if (trimmed.startsWith('- ')) {
        // Strip bullet point indicator and render with circle icon
        final bulletText = trimmed.substring(2);
        children.add(
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7.0, right: 10.0),
                  child: Icon(Icons.fiber_manual_record, size: 6, color: AppColors.primaryGreen),
                ),
                Expanded(
                  child: RichText(
                    text: _parseBoldText(bulletText),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (trimmed.startsWith('1. ') ||
          trimmed.startsWith('2. ') ||
          trimmed.startsWith('3. ') ||
          trimmed.startsWith('4. ')) {
        // Strip number listing prefix and style index separately
        final index = trimmed.indexOf('. ');
        final number = trimmed.substring(0, index + 1);
        final itemText = trimmed.substring(index + 2);
        children.add(
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number ',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: RichText(
                    text: _parseBoldText(itemText),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Render regular paragraph line
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: RichText(
              text: _parseBoldText(trimmed),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  // Formats inline text surrounded by ** into Bold spans
  TextSpan _parseBoldText(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;

    for (var match in regex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: GoogleFonts.inter(
            fontSize: 14.5,
            height: 1.6,
            color: AppColors.primaryText,
          ),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: GoogleFonts.inter(
          fontSize: 14.5,
          fontWeight: FontWeight.bold,
          height: 1.6,
          color: AppColors.primaryText,
        ),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: GoogleFonts.inter(
          fontSize: 14.5,
          height: 1.6,
          color: AppColors.primaryText,
        ),
      ));
    }

    return TextSpan(children: spans);
  }
}
