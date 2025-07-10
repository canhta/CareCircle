import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/care_group_models.dart';

class CareGroupCard extends StatelessWidget {
  final CareGroup group;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CareGroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildDescription(context),
              const SizedBox(height: 16),
              _buildStats(context),
              const SizedBox(height: 12),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.group,
            color: CareCircleDesignTokens.primaryMedicalBlue,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Created ${_formatDate(group.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (!group.isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Inactive',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (group.description == null || group.description!.isEmpty) {
      return Text(
        'No description provided',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Text(
      group.description!,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      children: [
        _buildStatChip(
          context,
          Icons.people,
          '${group.memberCount} members',
          CareCircleDesignTokens.primaryMedicalBlue,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          context,
          Icons.task_alt,
          '${group.activeTaskCount} tasks',
          group.activeTaskCount > 0
            ? Colors.orange[600]!
            : Colors.grey[600]!,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          context,
          Icons.favorite,
          '${group.careRecipients.length} recipients',
          CareCircleDesignTokens.healthGreen,
        ),
      ],
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMemberAvatars(context),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
      ],
    );
  }

  Widget _buildMemberAvatars(BuildContext context) {
    final displayMembers = group.members.take(3).toList();
    final remainingCount = group.members.length - displayMembers.length;

    return Row(
      children: [
        ...displayMembers.map((member) => Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.2),
            backgroundImage: member.photoUrl != null 
              ? NetworkImage(member.photoUrl!) 
              : null,
            child: member.photoUrl == null 
              ? Text(
                  _getInitials(member.displayName),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                  ),
                )
              : null,
          ),
        )),
        if (remainingCount > 0)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }
}
