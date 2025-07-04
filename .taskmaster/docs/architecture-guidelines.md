# CareCircle Backend Architecture Guidelines

## Module Organization Rules

### 1. Domain-Driven Design Principles

Each module should represent a specific business domain or technical concern:

#### Business Domain Modules
- `user/` - User management, authentication, profiles
- `health-record/` - Health records and medical data
- `prescription/` - Medication and prescription management
- `daily-check-in/` - Daily health check-ins
- `care-group/` - Care groups and caregiver relationships
- `document/` - Document management
- `notification/` - Notification system
- `insights/` - Health insights generation
- `alerts/` - Alert management and caregiver notifications
- `recommendations/` - Health recommendations
- `analytics/` - Data analysis and trend analysis

#### Technical Modules
- `ai/` - Core AI services (OpenAI, embeddings, personalized questions)
- `vector/` - Vector database operations
- `prisma/` - Database access layer
- `config/` - Configuration management

### 2. Service Placement Rules

#### ✅ DO: Place services in their appropriate domain module
- `InsightGeneratorService` → `insights/` module
- `CaregiverAlertService` → `alerts/` module
- `TrendAnalysisService` → `analytics/` module
- `RecommendationGeneratorService` → `recommendations/` module
- `HealthScoreCalculatorService` → `analytics/` module

#### ❌ DON'T: Place domain services in technical modules
- ❌ Domain services in `ai/` module (unless core AI functionality)
- ❌ Business logic in `prisma/` module
- ❌ Alert logic in unrelated modules

### 3. Module Structure Guidelines

Each module should follow this structure:
```
module-name/
├── module-name.module.ts        # Module definition
├── module-name.service.ts       # Primary service
├── module-name.controller.ts    # HTTP controllers
├── dto/                         # Data Transfer Objects
│   ├── create-entity.dto.ts
│   └── update-entity.dto.ts
├── interfaces/                  # TypeScript interfaces
│   └── module-interfaces.ts
└── guards/                      # Module-specific guards
    └── module.guard.ts
```

### 4. Dependency Rules

#### Import Hierarchy (from top to bottom)
1. **Domain Modules** can import:
   - Technical modules (`prisma/`, `ai/`, `vector/`, `config/`)
   - Other domain modules (with caution to avoid circular dependencies)

2. **Technical Modules** should:
   - Not import domain modules
   - Only import other technical modules or external libraries

#### Example Proper Dependencies
```typescript
// ✅ GOOD: Insights module importing technical modules
@Module({
  imports: [PrismaModule, AIModule],
  providers: [InsightGeneratorService],
  exports: [InsightGeneratorService],
})
export class InsightsModule {}

// ✅ GOOD: Analytics module with proper dependencies
@Module({
  imports: [ConfigModule, VectorModule, AIModule, PrismaModule],
  providers: [TrendAnalysisService, HealthScoreCalculatorService],
  exports: [TrendAnalysisService, HealthScoreCalculatorService],
})
export class AnalyticsModule {}
```

### 5. Service Responsibilities

#### AI Module Services
- `OpenAIService` - Core OpenAI API interactions
- `EmbeddingService` - Text embedding generation
- `PersonalizedQuestionService` - AI-powered question generation

#### Analytics Module Services
- `TrendAnalysisService` - Health trend analysis
- `HealthScoreCalculatorService` - Health score calculations
- `ResponseAnalysisService` - User response analysis
- `UserInteractionService` - User interaction analytics

#### Insights Module Services
- `InsightGeneratorService` - Health insights generation
- `InsightAggregatorService` - Insight aggregation and processing

#### Alerts Module Services
- `CaregiverAlertService` - Caregiver alert generation and management
- `AlertNotificationService` - Alert notification handling

#### Recommendations Module Services
- `RecommendationGeneratorService` - Health recommendation generation
- `RecommendationPersonalizationService` - Recommendation personalization

### 6. File Naming Conventions

#### Services
- `{domain}.service.ts` - Primary domain service
- `{specific-function}.service.ts` - Specific functionality service

#### Controllers
- `{domain}.controller.ts` - Primary domain controller
- `{specific-endpoint}.controller.ts` - Specific endpoint controller

#### Modules
- `{domain}.module.ts` - Domain module
- Always use kebab-case for directories and files

### 7. Cross-Module Communication

#### ✅ Preferred Patterns
1. **Service Injection**: Inject services from other modules
2. **Event-Driven**: Use NestJS events for loose coupling
3. **Shared Interfaces**: Define shared interfaces in a common location

#### ❌ Anti-Patterns
1. **Direct Database Access**: Don't bypass service layers
2. **Circular Dependencies**: Avoid modules importing each other
3. **God Services**: Don't create services that do everything

### 8. Testing Organization

Mirror the module structure in tests:
```
test/
├── insights/
│   └── insight-generator.service.spec.ts
├── alerts/
│   └── caregiver-alert.service.spec.ts
└── analytics/
    ├── trend-analysis.service.spec.ts
    └── health-score-calculator.service.spec.ts
```

### 9. Documentation Requirements

Each module should include:
- `README.md` - Module purpose and API documentation
- JSDoc comments on all public methods
- Interface documentation for complex types
- Usage examples for key services

### 10. Enforcement Checklist

Before creating or moving files, ask:
- [ ] Does this service belong to a specific business domain?
- [ ] Is this a technical utility or domain business logic?
- [ ] What other services does this depend on?
- [ ] Will this create circular dependencies?
- [ ] Does the module name clearly indicate its responsibility?
- [ ] Are the imports following the dependency hierarchy?

### 11. Migration Guidelines

When refactoring existing code:
1. Identify the primary domain responsibility
2. Create the target module if it doesn't exist
3. Move the service to the appropriate module
4. **Update all import paths** in the moved service files:
   - Change relative imports (e.g., `./openai.service`) to module imports (e.g., `../ai/openai.service`)
   - Update imports to other moved services (e.g., `../insights/insight-generator.service`)
5. Update all imports and module registrations
6. Update tests to match the new structure
7. Update documentation

#### Common Import Path Updates After Migration

```typescript
// Before migration (services in ai/ module)
import { OpenAIService } from './openai.service';
import { InsightGeneratorService } from './insight-generator.service';

// After migration (services moved to domain modules)
import { OpenAIService } from '../ai/openai.service';
import { InsightGeneratorService } from '../insights/insight-generator.service';
```

#### Import Path Patterns

- **From domain modules to AI module**: `../ai/openai.service`
- **From domain modules to other domain modules**: `../insights/insight-generator.service`
- **From domain modules to analytics**: `../analytics/response-analysis.service`
- **To Prisma module**: `../prisma/prisma.service`

### 12. Examples of Proper Organization

#### Before (Improper)
```
ai/
├── ai.module.ts
├── openai.service.ts
├── insight-generator.service.ts     # Domain logic in technical module
├── caregiver-alert.service.ts       # Domain logic in technical module
├── trend-analysis.service.ts        # Domain logic in technical module
└── recommendation-generator.service.ts # Domain logic in technical module
```

#### After (Proper)
```
ai/
├── ai.module.ts
├── openai.service.ts
├── embedding.service.ts
└── personalized-question.service.ts

insights/
├── insights.module.ts
└── insight-generator.service.ts

alerts/
├── alerts.module.ts
└── caregiver-alert.service.ts

analytics/
├── analytics.module.ts
├── trend-analysis.service.ts
└── health-score-calculator.service.ts

recommendations/
├── recommendations.module.ts
└── recommendation-generator.service.ts
```

## Enforcement

These rules should be:
1. Documented in the project README
2. Enforced during code reviews
3. Validated by automated linting rules where possible
4. Referenced when creating new features
5. Used as a checklist for architectural decisions
