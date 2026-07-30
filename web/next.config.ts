import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    remotePatterns: [
      { protocol: "https", hostname: "vsmov.com" },
      { protocol: "https", hostname: "**.vsmov.com" },
    ],
  },
};

export default nextConfig;
