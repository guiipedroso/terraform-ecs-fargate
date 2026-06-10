export default function Home() {
  const stack = [
    { label: "Container", value: "AWS ECS Fargate" },
    { label: "Infrastructure", value: "Terraform" },
    { label: "Load Balancer", value: "Application Load Balancer" },
    { label: "TLS", value: "AWS Certificate Manager" },
    { label: "DNS", value: "Amazon Route53" },
    { label: "Registry", value: "Amazon ECR" },
    { label: "Networking", value: "VPC + Private Subnets + NAT Gateway" },
    { label: "Logs", value: "Amazon CloudWatch" },
  ];

  return (
    <main style={styles.main}>
      <div style={styles.card}>
        <div style={styles.badge}>🚀 Running on AWS ECS Fargate</div>

        <h1 style={styles.title}>DevOps Engineer Academy</h1>

        <p style={styles.subtitle}>
          This portal is served by a containerized Next.js application deployed
          on <strong>Amazon ECS Fargate</strong>, provisioned entirely with{" "}
          <strong>Terraform</strong> following infrastructure as code best
          practices.
        </p>

        <div style={styles.divider} />

        <h2 style={styles.sectionTitle}>⚙️ Tech Stack</h2>

        <div style={styles.grid}>
          {stack.map(({ label, value }) => (
            <div key={label} style={styles.item}>
              <span style={styles.itemLabel}>{label}</span>
              <span style={styles.itemValue}>{value}</span>
            </div>
          ))}
        </div>

        <div style={styles.divider} />

        <div style={styles.footer}>
          <span>Built by </span>
          <a
            href="https://github.com/guiipedroso"
            target="_blank"
            rel="noopener noreferrer"
            style={styles.link}
          >
            Guilherme Pedroso
          </a>
          <span> · </span>
          <a
            href="https://linkedin.com/in/gui-pedroso"
            target="_blank"
            rel="noopener noreferrer"
            style={styles.link}
          >
            LinkedIn
          </a>
        </div>
      </div>
    </main>
  );
}

const styles: Record<string, React.CSSProperties> = {
  main: {
    minHeight: "100vh",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    padding: "2rem",
    background: "linear-gradient(135deg, #0f172a 0%, #1e293b 100%)",
  },
  card: {
    background: "#1e293b",
    border: "1px solid #334155",
    borderRadius: "16px",
    padding: "3rem",
    maxWidth: "680px",
    width: "100%",
    boxShadow: "0 25px 50px rgba(0,0,0,0.4)",
  },
  badge: {
    display: "inline-block",
    background: "#0ea5e920",
    color: "#38bdf8",
    border: "1px solid #0ea5e940",
    borderRadius: "999px",
    padding: "0.3rem 1rem",
    fontSize: "0.8rem",
    fontWeight: 600,
    marginBottom: "1.5rem",
    letterSpacing: "0.02em",
  },
  title: {
    color: "#f1f5f9",
    fontSize: "2rem",
    fontWeight: 800,
    margin: "0 0 1rem 0",
    lineHeight: 1.2,
  },
  subtitle: {
    color: "#94a3b8",
    fontSize: "1rem",
    lineHeight: 1.7,
    margin: 0,
  },
  divider: {
    height: "1px",
    background: "#334155",
    margin: "2rem 0",
  },
  sectionTitle: {
    color: "#e2e8f0",
    fontSize: "1rem",
    fontWeight: 700,
    margin: "0 0 1rem 0",
    textTransform: "uppercase",
    letterSpacing: "0.05em",
  },
  grid: {
    display: "flex",
    flexDirection: "column",
    gap: "0.6rem",
  },
  item: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    background: "#0f172a",
    borderRadius: "8px",
    padding: "0.6rem 1rem",
    gap: "1rem",
  },
  itemLabel: {
    color: "#64748b",
    fontSize: "0.85rem",
    fontWeight: 500,
    whiteSpace: "nowrap",
  },
  itemValue: {
    color: "#38bdf8",
    fontSize: "0.85rem",
    fontWeight: 600,
    textAlign: "right",
  },
  footer: {
    color: "#64748b",
    fontSize: "0.85rem",
    textAlign: "center",
  },
  link: {
    color: "#38bdf8",
    textDecoration: "none",
    fontWeight: 600,
  },
};
