# PDF Analysis Backend

This is the Python Flask backend for the PDF Analysis application. It provides REST APIs for PDF upload, processing, heading extraction, text-to-speech, and contradiction generation using AI models and machine learning.

## 🚀 Features

- **PDF Upload & Validation**: Secure file upload with size and type validation
- **AI-Powered Heading Extraction**: Machine learning-based heading detection using scikit-learn
- **Multiple LLM Integration**: Support for Gemini, OpenAI, and Azure LLM providers
- **Text-to-Speech**: Integration with Azure Speech Services and Google TTS
- **Contradiction Generation**: AI-powered generation of contradictory statements
- **RESTful API**: Clean, documented endpoints for frontend integration
- **Error Handling**: Comprehensive error handling and logging
- **CORS Support**: Configured for React frontend integration
- **File Management**: Organized file storage and retrieval

## 📋 Prerequisites

- Python 3.8 or higher
- pip (Python package installer)
- Docker (optional, for containerized deployment)

## 🛠 Setup Instructions

### Option 1: Local Development

#### 1. Create Virtual Environment

```bash
cd backend
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate
```

#### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

#### 3. Configure Environment Variables

Create a `.env` file in the backend directory:

```bash
# LLM Configuration
LLM_PROVIDER=gemini
GEMINI_API_KEY=your_actual_gemini_api_key
GEMINI_MODEL=gemini-2.5-flash

# Azure Speech Services (optional)
AZURE_SPEECH_KEY=your_azure_speech_key
AZURE_SPEECH_REGION=your_azure_region
TTS_PROVIDER=gcp

# Flask Configuration
FLASK_ENV=development
FLASK_DEBUG=true
```

#### 4. Run the Server

```bash
python app.py
```

The server will start on `http://localhost:5001`

### Option 2: Docker Development

```bash
# From the project root
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up backend

# Or build and run backend only
docker build -t pdf-analyzer-backend ./backend
docker run -p 5001:5001 -v $(pwd)/backend:/app pdf-analyzer-backend
```

## 📚 API Endpoints

### Health Check
```http
GET /health
```
**Response:**
```json
{
  "status": "healthy",
  "message": "PDF Analysis API is running",
  "version": "1.0.0"
}
```

### Upload PDF
```http
POST /upload
Content-Type: multipart/form-data
```
**Body:** `file` (PDF file)

**Response:**
```json
{
  "success": true,
  "filename": "document.pdf",
  "outline": [
    {
      "id": "unique_id",
      "text": "Introduction",
      "level": 1,
      "page": 1,
      "x": 100,
      "y": 200,
      "confidence": 0.95
    }
  ],
  "message": "Successfully processed PDF and found X headings"
}
```

### Get Outline
```http
GET /get-outline/<filename>
```

### List Files
```http
GET /files
```

### Generate Contradictions
```http
POST /generate-contradictory
Content-Type: application/json
```
**Body:**
```json
{
  "text": "This is a positive statement"
}
```

### Text-to-Speech
```http
POST /tts
Content-Type: application/json
```
**Body:**
```json
{
  "text": "Text to convert to speech"
}
```

## 🤖 AI Model Integration

The application uses multiple AI/ML components:

### 1. Heading Extraction Model

The backend includes a pre-trained scikit-learn model for heading detection:

```python
# Model file: heading_classifier_with_font_count_norm_textNorm_5.pkl
# Features: Font size, position, text normalization
# Output: Heading level classification (0=Title, 1=H1, 2=H2, 3=H3)
```

### 2. LLM Integration

Support for multiple LLM providers through the `LLMClient`:

```python
# Configure in .env file
LLM_PROVIDER=gemini  # Options: gemini, openai, azure
GEMINI_API_KEY=your_key
GEMINI_MODEL=gemini-2.5-flash
```

### 3. Text Embeddings

Uses sentence-transformers for semantic text processing:

```python
# Model: sentence-transformers/all-MiniLM-L6-v2
# Purpose: Text similarity and semantic analysis
```

### 4. Contradiction Generation

AI-powered contradiction generation using NLTK and LLM:

```python
# Features:
# - NLTK wordnet for antonym detection
# - Fallback negation mapping
# - LLM-based contradiction generation
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `LLM_PROVIDER` | AI provider (gemini/openai/azure) | gemini | Yes |
| `GEMINI_API_KEY` | Google Gemini API key | - | Yes |
| `GEMINI_MODEL` | Gemini model name | gemini-2.5-flash | No |
| `AZURE_SPEECH_KEY` | Azure Speech Services key | - | No |
| `AZURE_SPEECH_REGION` | Azure region | - | No |
| `TTS_PROVIDER` | TTS provider (azure/gcp) | gcp | No |
| `FLASK_ENV` | Flask environment | development | No |
| `FLASK_DEBUG` | Debug mode | true | No |

### File Upload Limits

```python
MAX_FILE_SIZE = 50 * 1024 * 1024  # 50MB
ALLOWED_EXTENSIONS = {'pdf'}
```

## 🛡 Security Features

- **File Type Validation**: Only PDF files accepted
- **File Size Limits**: Configurable maximum file size
- **Secure Filenames**: Uses `secure_filename()` to prevent path traversal
- **Input Validation**: Comprehensive request validation
- **Error Handling**: Detailed error responses without exposing internals
- **CORS Configuration**: Secure cross-origin resource sharing

## 📊 Logging

The application logs important events:

```python
# Log levels: INFO, WARNING, ERROR
# Logged events:
# - File uploads and processing
# - AI model inference results
# - API request/response cycles
# - Error conditions and exceptions
```

For production logging:

```python
import logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)
```

## 🚀 Production Deployment

### Using Docker

```bash
# Build production image
docker build -t pdf-analyzer-backend ./backend

# Run with environment variables
docker run -d \
  -p 5001:5001 \
  -e GEMINI_API_KEY=your_key \
  -e FLASK_ENV=production \
  -v backend_uploads:/app/uploads \
  pdf-analyzer-backend
```

### Using Docker Compose

```bash
# Production deployment
docker-compose up -d backend

# With custom configuration
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Using Gunicorn

```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5001 app:app
```

### Environment Setup

For production:

1. Set `FLASK_ENV=production`
2. Configure proper logging
3. Use a production WSGI server (Gunicorn, uWSGI)
4. Set up reverse proxy (Nginx)
5. Configure SSL/TLS
6. Set up monitoring and health checks

## 🧪 Testing

### API Testing

```bash
# Health check
curl http://localhost:5001/health

# Upload PDF
curl -X POST -F "file=@sample.pdf" http://localhost:5001/upload

# List files
curl http://localhost:5001/files

# Generate contradiction
curl -X POST -H "Content-Type: application/json" \
  -d '{"text":"This is good"}' \
  http://localhost:5001/generate-contradictory

# Text-to-speech
curl -X POST -H "Content-Type: application/json" \
  -d '{"text":"Hello world"}' \
  http://localhost:5001/tts
```

### Unit Testing

```bash
# Install test dependencies
pip install pytest pytest-flask

# Run tests
pytest tests/
```

## 📁 Project Structure

```
backend/
├── app.py                              # Main Flask application
├── requirements.txt                    # Python dependencies
├── Dockerfile                          # Container configuration
├── uploads/                            # PDF file storage
├── static/
│   └── audio/                         # Generated audio files
├── models/
│   └── heading_classifier_with_font_count_norm_textNorm_5.pkl
├── RePDFBuilding.py                    # PDF processing utilities
├── RePDFBuildingNegative.py           # Negative highlighting
├── TextProcessor.py                    # Text processing utilities
├── llmProvider.py                      # LLM client implementation
├── generateContra.py                   # Contradiction generation
└── README.md                           # This file
```

## 🔄 Dependencies

### Core Dependencies
- **Flask**: Web framework
- **PyMuPDF**: PDF processing
- **scikit-learn**: Machine learning models
- **sentence-transformers**: Text embeddings
- **pandas**: Data manipulation
- **numpy**: Numerical computing

### AI/ML Dependencies
- **google-generativeai**: Gemini API integration
- **azure-cognitiveservices-speech**: Azure Speech Services
- **gTTS**: Google Text-to-Speech
- **litellm**: LLM abstraction layer
- **nltk**: Natural language processing

### Utility Dependencies
- **Flask-CORS**: Cross-origin resource sharing
- **Werkzeug**: WSGI utilities
- **python-multipart**: File upload handling
- **joblib**: Model serialization

## 🐛 Troubleshooting

### Common Issues

1. **Port Already in Use**:
   ```bash
   lsof -ti:5001 | xargs kill -9
   ```

2. **Permission Errors**:
   ```bash
   chmod 755 uploads/
   chmod 755 static/audio/
   ```

3. **Module Import Errors**:
   ```bash
   # Ensure virtual environment is activated
   source venv/bin/activate
   pip install -r requirements.txt
   ```

4. **API Key Issues**:
   ```bash
   # Verify environment variables
   echo $GEMINI_API_KEY
   # Check .env file
   cat .env
   ```

5. **Model Loading Errors**:
   ```bash
   # Ensure model file exists
   ls -la heading_classifier_with_font_count_norm_textNorm_5.pkl
   ```

### Debug Mode

```bash
# Enable debug logging
export FLASK_DEBUG=true
export PYTHONUNBUFFERED=1

# Run with debug output
python app.py
```

## 📞 Support

For questions or issues:

1. Check the logs for error details
2. Verify all dependencies are installed
3. Ensure Python version compatibility
4. Test API endpoints individually
5. Verify environment variable configuration

## 🔮 Future Enhancements

- **Database Integration**: Store processing results and user data
- **Caching**: Implement Redis caching for processed PDFs
- **Batch Processing**: Add support for processing multiple PDFs
- **Authentication**: Implement user authentication and authorization
- **Monitoring**: Add application monitoring and metrics
- **API Documentation**: Generate OpenAPI/Swagger documentation

---

**Ready to process PDFs with AI-powered analysis!** 🚀📄🤖