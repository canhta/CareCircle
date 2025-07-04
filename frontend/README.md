# CareCircle Admin Portal

A Next.js-based administrative web portal for the CareCircle platform.

[![Frontend Build Status](https://img.shields.io/badge/build-passing-brightgreen)](../)

## Description

The CareCircle admin portal provides comprehensive dashboards and management tools for system administrators, including user management, system health monitoring, AI cost tracking, and analytics.

## Project Structure

```
frontend/
  ├── app/
  ├── lib/
  ├── public/
  ├── package.json
  └── ...
```

## Features

- System health dashboards
- User management and analytics
- AI cost monitoring
- Content moderation tools
- Analytics and reporting
- Configuration management

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

## Environment Variables

| Variable            | Description          | Example                   |
| ------------------- | -------------------- | ------------------------- |
| NEXT_PUBLIC_API_URL | Backend API base URL | http://localhost:3000/api |
| ...                 | ...                  | ...                       |

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Related Docs

- [Backend README](../backend/README.md)
- [Mobile README](../mobile/README.md)
- [Docker README](../docker/README.md)

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
