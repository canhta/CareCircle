#!/bin/bash

# Script to add missing switch cases for new HealthMetricType enum values

# Files to fix
files=(
  "lib/features/health_data/presentation/widgets/device_permissions_widget.dart"
  "lib/features/health_data/presentation/widgets/goal_card.dart"
  "lib/features/health_data/presentation/widgets/health_metric_card.dart"
  "lib/features/health_data/presentation/widgets/recent_metrics_list.dart"
)

# Function to add missing cases after exercise case
add_missing_cases() {
  local file="$1"
  
  # Add missing cases for color/icon switches
  sed -i '/case HealthMetricType\.exercise:/,/^[[:space:]]*}[[:space:]]*$/{
    /case HealthMetricType\.exercise:/a\
      case HealthMetricType.respiratoryRate:\
        return Colors.lightBlue[600]!;\
      case HealthMetricType.activity:\
        return Colors.lime[600]!;\
      case HealthMetricType.mood:\
        return Colors.pink[600]!;
  }' "$file"
  
  # Add missing cases for icon switches
  sed -i '/case HealthMetricType\.exercise:/,/^[[:space:]]*}[[:space:]]*$/{
    /case HealthMetricType\.exercise:/a\
      case HealthMetricType.respiratoryRate:\
        return Icons.air;\
      case HealthMetricType.activity:\
        return Icons.directions_run;\
      case HealthMetricType.mood:\
        return Icons.mood;
  }' "$file"
}

# Process each file
for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "Processing $file..."
    add_missing_cases "$file"
  else
    echo "File not found: $file"
  fi
done

echo "Done!"
