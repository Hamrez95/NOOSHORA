/** @type {import('next').NextConfig} */
const nextConfig = {
  output: process.env.NOOSHORA_STATIC_EXPORT === 'true' ? 'export' : undefined,
  images: {
    unoptimized: process.env.NOOSHORA_STATIC_EXPORT === 'true',
  },
  poweredByHeader: false,
};

export default nextConfig;
