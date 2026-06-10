import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "DevOps Engineer Academy",
  description: "Container infrastructure running on AWS ECS Fargate",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body style={{ margin: 0, fontFamily: "system-ui, sans-serif", background: "#0f172a" }}>
        {children}
      </body>
    </html>
  );
}
