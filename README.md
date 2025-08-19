[README.md](https://github.com/user-attachments/files/21869193/README.md)
# PDF Analysis Tool

A modern, AI-powered web application for analyzing PDF documents with intelligent heading extraction, text-to-speech capabilities, and contradiction generation. Built with React.js frontend and Python Flask backend.

## 🚀 Overview

This project provides a comprehensive solution for PDF document analysis with the following key features:

- **📄 PDF Upload & Processing**: Drag-and-drop interface for multiple PDF files
- **🤖 AI-Powered Analysis**: Intelligent heading extraction using machine learning models
- **🔍 Document Navigation**: Interactive outline with hierarchical heading structure
- **🎵 Text-to-Speech**: Audio playback of document content with multiple TTS providers
- **🔄 Contradiction Generation**: AI-powered generation of contradictory statements
- **📱 Responsive Design**: Mobile-friendly interface with modern UI/UX

## 🏗️ Architecture

The application is built with a modern microservices architecture:

- **Frontend**: React + TypeScript + Vite with Tailwind CSS
- **Backend**: Python Flask with AI/ML capabilities
- **Infrastructure**: Docker containerization with Redis caching
- **AI/ML**: Multiple LLM providers, scikit-learn models, and text embeddings

## 📁 Project Structure

```
LAST/
├── finale/                    # Main application directory
│   ├── src/                  # React frontend source
│   │   ├── components/       # Reusable UI components
│   │   ├── context/         # React context providers
│   │   ├── pages/           # Main page components
│   │   └── App.tsx          # Main app component
│   ├── backend/             # Python Flask backend
│   │   ├── app.py           # Flask application
│   │   ├── requirements.txt # Python dependencies
│   │   ├── uploads/         # PDF file storage
│   │   └── models/          # ML model files
│   ├── docker-compose.yml   # Production Docker setup
│   ├── docker-compose.dev.yml # Development Docker setup
│   ├── Dockerfile           # Production frontend
│   ├── Dockerfile.dev       # Development frontend
│   ├── package.json         # Node.js dependencies
│   ├── vite.config.ts       # Vite configuration
│   ├── README.md            # Main application README
│   ├── backend/README.md    # Backend documentation
│   └── README-Docker.md     # Docker deployment guide
└── README.md                # This file
```

## 🛠 Technology Stack

### Frontend
- **React 18** with TypeScript for type safety
- **Vite** for fast development and building
- **React Router** for client-side navigation
- **Framer Motion** for smooth animations
- **React Dropzone** for drag-and-drop file uploads
- **Tailwind CSS** for modern, responsive styling
- **Lucide React** for beautiful, consistent icons

### Backend
- **Python Flask** for lightweight, flexible API server
- **PyMuPDF** for PDF processing and text extraction
- **scikit-learn** for machine learning models
- **sentence-transformers** for text embeddings
- **Azure Speech Services** for text-to-speech
- **Google Generative AI** for LLM integration
- **Flask-CORS** for seamless frontend integration

### Infrastructure
- **Docker** for containerization
- **Docker Compose** for multi-service orchestration
- **Redis** for caching and session management
- **Nginx** for reverse proxy (production)

## 🚀 Quick Start

### Prerequisites

- **Node.js** (18+ recommended)
- **Python** (3.8+ required)
- **Docker** (20.10+ for containerized deployment)
- **npm** or **yarn** package manager

### Option 1: Local Development

#### Frontend Setup
```bash
cd finale
npm install
npm run dev
```
Access at: http://localhost:5173

#### Backend Setup
```bash
cd finale/backend
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
python app.py
```
Access at: http://localhost:5001

### Option 2: Docker Development

```bash
cd finale
cp env.example .env
# Edit .env with your API keys
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

### Option 3: Production Deployment

```bash
cd finale
cp env.example .env
# Edit .env with production settings
docker-compose up -d
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the `finale` directory:

```bash
# Required: LLM Configuration
LLM_PROVIDER=gemini
GEMINI_API_KEY=your_actual_gemini_api_key
GEMINI_MODEL=gemini-2.5-flash

# Optional: Azure Speech Services
AZURE_SPEECH_KEY=your_azure_speech_key
AZURE_SPEECH_REGION=your_azure_region
TTS_PROVIDER=gcp

# Flask Configuration
FLASK_ENV=production
FLASK_DEBUG=false

# Frontend Configuration
REACT_APP_API_URL=http://localhost/api
NODE_ENV=production
```

### API Keys Required

1. **Google Gemini API Key**: For AI-powered text analysis
2. **Azure Speech Services** (optional): For enhanced text-to-speech
3. **OpenAI API Key** (optional): Alternative LLM provider

## 📚 Documentation

### Main Documentation
- **[Application README](finale/README.md)**: Comprehensive guide to the main application
- **[Backend README](finale/backend/README.md)**: Detailed backend documentation
- **[Docker README](finale/README-Docker.md)**: Docker deployment and management guide

### Key Features Documentation

#### PDF Processing
- Multi-file upload with drag-and-drop
- AI-powered heading extraction
- Interactive document navigation
- Text highlighting and search

#### AI Capabilities
- Multiple LLM provider support (Gemini, OpenAI, Azure)
- Contradiction generation
- Text-to-speech with multiple providers
- Machine learning model integration

#### Technical Features
- TypeScript for type safety
- Docker containerization
- Redis caching
- Comprehensive error handling
- Production-ready deployment

## 🔌 API Endpoints

### Core Endpoints
```bash
# Health check
GET /health

# Upload and process PDF
POST /upload
Content-Type: multipart/form-data

# Get outline for PDF
GET /get-outline/<filename>

# List all uploaded files
GET /files

# Generate contradictions
POST /generate-contradictory
Content-Type: application/json

# Text-to-speech
POST /tts
Content-Type: application/json
```

## 🚀 Deployment

### Docker Commands

```bash
# Development
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Production
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild containers
docker-compose build --no-cache
```

### Production Checklist

- [ ] Configure environment variables
- [ ] Set up SSL certificates (for HTTPS)
- [ ] Configure monitoring and logging
- [ ] Set up backup strategy
- [ ] Test all features thoroughly
- [ ] Configure resource limits

## 🧪 Testing

### Manual Testing

```bash
# Test health endpoints
curl http://localhost:5001/health
curl http://localhost:5173

# Test file upload
curl -X POST -F "file=@sample.pdf" http://localhost:5001/upload

# Test API endpoints
curl http://localhost:5001/files
```

### Development Testing

1. Upload single and multiple PDF files
2. Test document navigation and outline
3. Verify text-to-speech functionality
4. Test contradiction generation
5. Check responsive design on mobile
6. Verify error handling

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes with proper commit messages
4. Test thoroughly on both frontend and backend
5. Push to your branch: `git push origin feature-name`
6. Submit a pull request with detailed description

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **React team** for the excellent framework and ecosystem
- **Vite** for the fast build tool
- **Tailwind CSS** for the beautiful styling system
- **Flask** for the lightweight backend framework
- **PyMuPDF** for robust PDF processing
- **Google Gemini** and **Azure Speech** for AI capabilities

## 📞 Support

For questions, issues, or contributions:

1. **Issues**: Open a GitHub issue with detailed description
2. **Features**: Submit feature requests with use cases
3. **Documentation**: Help improve documentation and examples
4. **Testing**: Report bugs and edge cases

## 🔮 Future Enhancements

- **Database Integration**: Store processing results and user data
- **Authentication**: Implement user authentication and authorization
- **Batch Processing**: Add support for processing multiple PDFs
- **Advanced AI**: Integration with more sophisticated AI models
- **API Documentation**: Generate OpenAPI/Swagger documentation
- **Monitoring**: Add application monitoring and metrics

---

**Built with modern web technologies and AI capabilities** 🚀📄✨

For detailed documentation, see the [finale/README.md](finale/README.md) file.
