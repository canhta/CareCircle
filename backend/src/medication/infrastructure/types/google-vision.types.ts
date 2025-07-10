/**
 * Google Vision API Type Definitions
 *
 * Proper TypeScript interfaces for Google Vision API responses
 * to replace 'any' types and improve type safety.
 */

// =============================================================================
// Google Vision API Response Types
// =============================================================================

export interface GoogleVisionResponse {
  responses: GoogleVisionAnnotateResponse[];
}

export interface GoogleVisionAnnotateResponse {
  textAnnotations?: TextAnnotation[];
  fullTextAnnotation?: FullTextAnnotation;
  error?: GoogleVisionError;
}

export interface TextAnnotation {
  locale?: string;
  description: string;
  boundingPoly?: BoundingPoly;
}

export interface FullTextAnnotation {
  pages: Page[];
  text: string;
}

export interface Page {
  property?: TextProperty;
  width: number;
  height: number;
  blocks: Block[];
}

export interface Block {
  property?: TextProperty;
  boundingBox?: BoundingPoly;
  paragraphs: Paragraph[];
  blockType?: string;
}

export interface Paragraph {
  property?: TextProperty;
  boundingBox?: BoundingPoly;
  words: Word[];
}

export interface Word {
  property?: TextProperty;
  boundingBox?: BoundingPoly;
  symbols: Symbol[];
  confidence?: number;
}

export interface Symbol {
  property?: TextProperty;
  boundingBox?: BoundingPoly;
  text: string;
  confidence?: number;
}

export interface BoundingPoly {
  vertices: Vertex[];
  normalizedVertices?: NormalizedVertex[];
}

export interface Vertex {
  x?: number;
  y?: number;
}

export interface NormalizedVertex {
  x?: number;
  y?: number;
}

export interface TextProperty {
  detectedLanguages?: DetectedLanguage[];
  detectedBreak?: DetectedBreak;
}

export interface DetectedLanguage {
  languageCode: string;
  confidence?: number;
}

export interface DetectedBreak {
  type: BreakType;
  isPrefix?: boolean;
}

export enum BreakType {
  UNKNOWN = 'UNKNOWN',
  SPACE = 'SPACE',
  SURE_SPACE = 'SURE_SPACE',
  EOL_SURE_SPACE = 'EOL_SURE_SPACE',
  HYPHEN = 'HYPHEN',
  LINE_BREAK = 'LINE_BREAK',
}

export interface GoogleVisionError {
  code: number;
  message: string;
  details?: any[];
}

// =============================================================================
// OCR Processing Result Types
// =============================================================================

export interface OCRProcessingResult {
  success: boolean;
  confidence: number;
  extractedText: string;
  structuredData: OCRStructuredData;
  error?: string;
}

export interface OCRStructuredData {
  prescribedBy?: string;
  prescribedDate?: string;
  pharmacy?: string;
  medications: OCRMedicationData[];
}

export interface OCRMedicationData {
  name: string;
  strength?: string;
  form?: string;
  instructions?: string;
  quantity?: string;
  refills?: string;
  confidence: number;
}

// =============================================================================
// Type Guards
// =============================================================================

export function isGoogleVisionResponse(
  obj: unknown,
): obj is GoogleVisionResponse {
  return (
    obj !== null &&
    typeof obj === 'object' &&
    Array.isArray((obj as { responses?: unknown }).responses)
  );
}

export function isTextAnnotation(obj: unknown): obj is TextAnnotation {
  return (
    obj !== null &&
    typeof obj === 'object' &&
    typeof (obj as { description?: unknown }).description === 'string'
  );
}

export function hasTextAnnotations(
  response: GoogleVisionAnnotateResponse,
): boolean {
  return (
    Array.isArray(response.textAnnotations) &&
    response.textAnnotations.length > 0
  );
}

export function hasFullTextAnnotation(
  response: GoogleVisionAnnotateResponse,
): boolean {
  return (
    response.fullTextAnnotation !== undefined &&
    response.fullTextAnnotation !== null
  );
}
